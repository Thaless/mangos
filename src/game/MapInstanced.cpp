/*
 * Copyright (C) 2005-2009 MaNGOS <http://getmangos.com/>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include "MapInstanced.h"
#include "ObjectMgr.h"
#include "MapManager.h"
#include "BattleGround.h"
#include "VMapFactory.h"
#include "InstanceSaveMgr.h"
#include "World.h"

MapInstanced::MapInstanced(uint32 id, time_t expiry) : Map(id, expiry, 0, 0)
{
    // initialize instanced maps list
    m_InstancedMaps.clear();
    // fill with zero
    memset(&GridMapReference, 0, MAX_NUMBER_OF_GRIDS*MAX_NUMBER_OF_GRIDS*sizeof(uint16));
}

void MapInstanced::InitVisibilityDistance()
{
    if(m_InstancedMaps.empty())
        return;
    //initialize visibility distances for all instance copies
    for (InstancedMaps::iterator i = m_InstancedMaps.begin(); i != m_InstancedMaps.end(); ++i)
    {
        (*i).second->InitVisibilityDistance();
    }
}

void MapInstanced::Update(const uint32& t)
{
    // take care of loaded GridMaps (when unused, unload it!)
    Map::Update(t);

    // update the instanced maps
    InstancedMaps::iterator i = m_InstancedMaps.begin();

    while (i != m_InstancedMaps.end())
    {
        if(i->second->CanUnload(t))
        {
            DestroyInstance(i);                             // iterator incremented
        }
        else
        {
            // update only here, because it may schedule some bad things before delete
            i->second->Update(t);
            ++i;
        }
    }
}

void MapInstanced::MoveAllCreaturesInMoveList()
{
    for (InstancedMaps::iterator i = m_InstancedMaps.begin(); i != m_InstancedMaps.end(); ++i)
    {
        i->second->MoveAllCreaturesInMoveList();
    }

    Map::MoveAllCreaturesInMoveList();
}

void MapInstanced::RemoveAllObjectsInRemoveList()
{
    for (InstancedMaps::iterator i = m_InstancedMaps.begin(); i != m_InstancedMaps.end(); ++i)
    {
        i->second->RemoveAllObjectsInRemoveList();
    }

    Map::RemoveAllObjectsInRemoveList();
}

bool MapInstanced::RemoveBones(uint64 guid, float x, float y)
{
    bool remove_result = false;

    for (InstancedMaps::iterator i = m_InstancedMaps.begin(); i != m_InstancedMaps.end(); ++i)
    {
        remove_result = remove_result || i->second->RemoveBones(guid, x, y);
    }

    return remove_result || Map::RemoveBones(guid,x,y);
}

void MapInstanced::UnloadAll(bool pForce)
{
    // Unload instanced maps
    for (InstancedMaps::iterator i = m_InstancedMaps.begin(); i != m_InstancedMaps.end(); ++i)
        i->second->UnloadAll(pForce);

    // Delete the maps only after everything is unloaded to prevent crashes
    for (InstancedMaps::iterator i = m_InstancedMaps.begin(); i != m_InstancedMaps.end(); ++i)
        delete i->second;

    m_InstancedMaps.clear();

    // Unload own grids (just dummy(placeholder) grids, neccesary to unload GridMaps!)
    Map::UnloadAll(pForce);
}

/*
- return the right instance for the object, based on its InstanceId
- create the instance if it's not created already
- the player is not actually added to the instance (only in InstanceMap::Add)
*/
Map* MapInstanced::CreateInstance(const uint32 mapId, Player * player)
{
    if(GetId() != mapId || !player)
        return NULL;

    Map* map = NULL;
    uint32 NewInstanceId = 0;                       // instanceId of the resulting map

    if(IsBattleGroundOrArena())
    {
        // instantiate or find existing bg map for player
        // the instance id is set in battlegroundid
        NewInstanceId = player->GetBattleGroundId();
        ASSERT(NewInstanceId);
        map = _FindMap(NewInstanceId);
        if (!map)
        {
            map = CreateBattleGround(NewInstanceId);
            // add a pointer to the battleground to the map
            ((BattleGroundMap*)map)->SetBG(player->GetBattleGround());
        }
        if(!((BattleGroundMap*)map)->GetBG())
            if(player->GetBattleGround())
                player->GetBattleGround()->EndBattleGround(0); //to avoid the assert
    }
    else
    {
        InstancePlayerBind *pBind = player->GetBoundInstance(GetId(), player->GetDifficulty());
        InstanceSave *pSave = pBind ? pBind->save : NULL;

        // the player's permanent player bind is taken into consideration first
        // then the player's group bind and finally the solo bind.
        if(!pBind || !pBind->perm)
        {
            InstanceGroupBind *groupBind = NULL;
            Group *group = player->GetGroup();
            // use the player's difficulty setting (it may not be the same as the group's)
            if(group && (groupBind = group->GetBoundInstance(GetId(), player->GetDifficulty())))
                pSave = groupBind->save;
        }

        if(pSave)
        {
            // solo/perm/group
            NewInstanceId = pSave->GetInstanceId();
            map = _FindMap(NewInstanceId);
            // it is possible that the save exists but the map doesn't
            if(!map)
                map = CreateInstance(NewInstanceId, pSave, pSave->GetDifficulty());
        }
        else
        {
            // if no instanceId via group members or instance saves is found
            // the instance will be created for the first time
            NewInstanceId = MapManager::Instance().GenerateInstanceId();
            map = CreateInstance(NewInstanceId, NULL, player->GetDifficulty());
        }
    }

    return map;
}

InstanceMap* MapInstanced::CreateInstance(uint32 InstanceId, InstanceSave *save, uint8 difficulty)
{
    // load/create a map
    Guard guard(*this);

    // make sure we have a valid map id
    const MapEntry* entry = sMapStore.LookupEntry(GetId());
    if(!entry)
    {
        sLog.outError("CreateInstance: no entry for map %d", GetId());
        assert(false);
    }
    const InstanceTemplate * iTemplate = objmgr.GetInstanceTemplate(GetId());
    if(!iTemplate)
    {
        sLog.outError("CreateInstance: no instance template for map %d", GetId());
        assert(false);
    }

    // some instances only have one difficulty
    if (entry && !entry->SupportsHeroicMode()) difficulty = DIFFICULTY_NORMAL;

    sLog.outDebug("MapInstanced::CreateInstance: %s map instance %d for %d created with difficulty %s", save?"":"new ", InstanceId, GetId(), difficulty?"heroic":"normal");

    InstanceMap *map = new InstanceMap(GetId(), GetGridExpiry(), InstanceId, difficulty, this);
    ASSERT(map->IsDungeon());

    bool load_data = save != NULL;
    map->CreateInstanceData(load_data);

    m_InstancedMaps[InstanceId] = map;
    return map;
}

BattleGroundMap* MapInstanced::CreateBattleGround(uint32 InstanceId)
{
    // load/create a map
    Guard guard(*this);

    sLog.outDebug("MapInstanced::CreateBattleGround: map bg %d for %d created.", InstanceId, GetId());

    BattleGroundMap *map = new BattleGroundMap(GetId(), GetGridExpiry(), InstanceId, this);
    ASSERT(map->IsBattleGroundOrArena());

    m_InstancedMaps[InstanceId] = map;
    return map;
}

void MapInstanced::DestroyInstance(uint32 InstanceId)
{
    InstancedMaps::iterator itr = m_InstancedMaps.find(InstanceId);
    if(itr != m_InstancedMaps.end())
        DestroyInstance(itr);
}

// increments the iterator after erase
void MapInstanced::DestroyInstance(InstancedMaps::iterator &itr)
{
    itr->second->UnloadAll(true);
    // should only unload VMaps if this is the last instance and grid unloading is enabled
    if(m_InstancedMaps.size() <= 1 && sWorld.getConfig(CONFIG_GRID_UNLOAD))
    {
        VMAP::VMapFactory::createOrGetVMapManager()->unloadMap(itr->second->GetId());
        // in that case, unload grids of the base map, too
        // so in the next map creation, (EnsureGridCreated actually) VMaps will be reloaded
        Map::UnloadAll(true);
    }
    // erase map
    delete itr->second;
    m_InstancedMaps.erase(itr++);
}

[GameMode]
class RogueLiteGameMode : HW2GameMode
{

	RogueLiteGameMode(Scene@ scene)
	{
		super(scene);
	}

	void SpawnPlayer(int i, vec2 pos = vec2(-1, -1), int unitId = 0, uint team = 0) override
	{
		if (g_players[i].peer == 255)
			return;

		if (g_players[i].actor !is null)
			return;
		
		print("Spawn player " + g_players[i].peer);

		UnitPtr unit;
		vec3 spawnPos = xyz(pos);
		if (Network::IsServer() && pos.x == -1 && pos.y == -1)
			spawnPos = xyz(GetPlayerSpawnPosition(g_players[i]));

		if (g_players[i].local)
			unit = Resources::GetUnitProducer("players/towerplayer.unit").Produce(g_scene, spawnPos, unitId);
		else
			unit = Resources::GetUnitProducer("players/player_husk.unit").Produce(g_scene, spawnPos, unitId);
			
		if (!unit.IsValid())
		{
			if (g_players[i].local)
				PrintError("Failed to spawn local player unit for player " + i);
			else
				PrintError("Failed to spawn player unit for player " + i);
			return;
		}

		g_players[i].AssignUnit(unit);

		if (team > 0)
			g_players[i].actor.SetTeam(team);

		if (Network::IsServer())
			(Network::Message("SpawnPlayer") << g_players[i].peer << xy(unit.GetPosition()) << unit.GetId() << team).SendToAll();

		cast<PlayerBase>(unit.GetScriptBehavior()).Initialize(g_players[i]);
		Hooks::Call("GameModeSpawnPlayer", @this, @g_players[i]);
	}
}
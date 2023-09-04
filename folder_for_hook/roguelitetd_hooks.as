namespace roguelitetd
{

	[Hook]
	void GameModeRenderFrame(BaseGameMode@ baseGameMode, int idt, SpriteBatch& sb) {
		vec2 playerSpawnPos = baseGameMode.GetPlayerSpawnPosition(GetLocalPlayerRecord());
		auto ply = cast<TowerPlayer>(GetLocalPlayer());

		// Draw circle overlay in middle of screen
		sb.DrawCircle(vec2(baseGameMode.m_wndSWidth/2, baseGameMode.m_wndSHeight/2), ply.m_radius, vec4(0, 0, 0, 0.5f), 35);
	}

	[Hook]
	void HUDConstructor(HUD@ hud, GUIBuilder@ b)
	{
		print("Hook HUDConstructor called");
		hud.m_components.insertLast(PlayerTowerUpgrades(b));
	}
}
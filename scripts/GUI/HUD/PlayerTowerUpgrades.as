class PlayerTowerUpgrades : HUDComponent
{

	TextWidget@ m_wGold;
	TextWidget@ m_wWave;
	TextWidget@ m_wHealth;

	bool m_addedAsRoot;
	bool m_hovering;


	PlayerTowerUpgrades(GUIBuilder@ b)
	{
		super(b, "gui/playertowerupgrades.gui");

		@m_wGold = cast<TextWidget>(m_widget.GetWidgetById("gold"));
		@m_wWave = cast<TextWidget>(m_widget.GetWidgetById("wave"));
		@m_wHealth = cast<TextWidget>(m_widget.GetWidgetById("hp"));

		m_addedAsRoot = false;
	}

	void Update(int dt, PlayerRecord@ record) override
	{
		if (!m_visible)
			return;

		HUDComponent::Update(dt, record);

		bool hovering = false;
		for (uint i = 0; i < m_widget.m_children.length(); i++)
		{
			if(HoveringWidget(m_widget.m_children[i]))
			{
				hovering = true;
				break;
			}
		}

		if (!m_addedAsRoot && hovering)
			OnMouseEnter();
		else if (m_addedAsRoot && !hovering)
			OnMouseLeave();
	}

	void OnMouseEnter()
	{
		BaseGameMode@ gm = cast<BaseGameMode>(g_gameMode);
		if (gm is null)
			return;

		if (m_addedAsRoot)
			return;

		m_addedAsRoot = true;
		m_hovering = true;
		gm.AddWidgetRoot(this);

		for (uint i = 0; i < m_widget.m_children.length(); i++)
			m_widget.m_children[i].SetHovering(true, vec2(), true);

		Invalidate();
	}

	void OnMouseLeave()
	{
		BaseGameMode@ gm = cast<BaseGameMode>(g_gameMode);
		if (gm is null)
			return;

		if (!m_addedAsRoot)
			return;

		m_addedAsRoot = false;
		m_hovering = false;
		gm.RemoveWidgetRoot(this);

		for (uint i = 0; i < m_widget.m_children.length(); i++)
			m_widget.m_children[i].SetHovering(false, vec2());

		Invalidate();
	}

	bool HoveringWidget(Widget@ widget)
	{
		BaseGameMode@ gm = cast<BaseGameMode>(g_gameMode);
		if (gm is null)
			return false;

		vec2 mousePos = gm.GetMousePos();
		vec4 rect = vec4(
			widget.m_origin.x * g_gameMode.m_wndScale * m_scale,
			widget.m_origin.y * g_gameMode.m_wndScale * m_scale,
			(widget.m_origin.x + widget.m_width) * g_gameMode.m_wndScale * m_scale,
			(widget.m_origin.y + widget.m_height) * g_gameMode.m_wndScale * m_scale
		);

		return (mousePos.x >= rect.x && mousePos.x < rect.z && mousePos.y >= rect.y && mousePos.y < rect.w);
	}

	void OnFunc(Widget@ sender, const string &in name) override
	{
		auto ply = cast<TowerPlayer>(GetLocalPlayer());
		//auto parse = name.split(" ");
		if(name == "range")
			ply.m_radius += 10;

		print(ply.m_radius);
	}
}
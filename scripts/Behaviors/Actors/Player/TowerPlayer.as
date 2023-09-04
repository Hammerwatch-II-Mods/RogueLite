class TowerPlayer : Player
{
	// attack speed
	// dt = 33ms
	int m_attackCooldown = 660;
	int m_attackCooldownReset = 660;
	int m_radius = 100; // range
	int m_multiShot = 1; // shoot amount of arrows
	int m_attackspeed;
	int m_damage;

	UnitProducer@ m_projectile;
	TowerPlayer(UnitPtr unit, SValue& params) {
		super(unit, params);

		@m_projectile = Resources::GetUnitProducer("players/ranger/projectiles/ran_arrow_td.unit");
		//m_projectile.
		//m_damage = GetParamInt(unit, params, "physical", false, 1);
		//print("==========================" + m_projectile.m_hitEffects.m_effects + "==========================" );
		@m_forcedMovement = ForcedMovement(vec2(), 0.0f);
	}

	void Initialize(PlayerRecord@ record) override
	{
		Player::Initialize(record);

		// If monster collides with you, you'll float
		// Let's disable collision
		m_unit.SetShouldCollide(false);
	}

	void Update(int dt) override
	{
		// And now you stay still on the position
		m_unit.GetPhysicsBody().SetLinearVelocity(vec2());

		// Shoot delay
		if (m_attackCooldown > 0)
		{
			m_attackCooldown -= dt;
			if (m_attackCooldown <= 0)
			{
				// Reset shoot cooldown
				m_attackCooldown = m_attackCooldownReset;

				// our own position
				vec2 pos = xy(m_unit.GetPosition());

				//
				array<UnitPtr>@ results = g_scene.QueryCircle(pos, m_radius, ~0, RaycastType::Shot);
				for(uint i = 0; i < m_multiShot; i++)
				{
					if(results[i] == m_unit)
						continue;

					// Enemy in circle range
					Actor@ target = cast<Actor@>(results[i].GetScriptBehavior());

					if (m_projectile is null)
						return;

					vec2 shootDir;
					if (target !is null)
						shootDir = normalize(xy(target.m_unit.GetPosition() - m_unit.GetPosition()));
					else
						shootDir = randdir();

					UnitPtr proj = m_projectile.Produce(g_scene, m_unit.GetPosition());
					if (!proj.IsValid())
						return;

					NewProjectile@ p = cast<NewProjectile>(proj.GetScriptBehavior());
					if (p is null)
						return;

					// m_weaponInfo is a uint, but what is it for?
					//p.Initialize(m_owner, ProjectileTargetDir(shootDir, target), 1.0, false, m_weaponInfo);
					p.Initialize(m_unit, ProjectileTargetDir(shootDir, target), 1.0, false, 0);

				//if (target !is null)
				//{
				//	auto pp = cast<ProjectileBase>(proj.GetScriptBehavior());
				//	if (pp !is null && pp.m_seeking)
				//		pp.m_seekTarget = target.m_unit;
				//}

				//m_unit.Destroy();
				}
			}
		}
		//Player::Update(dt);
	}
}
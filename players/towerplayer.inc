<unit slot="actor" netsync="manual">
%if PLAYER_HUSK
	<behavior class="PlayerHusk">
%else
	<behavior class="TowerPlayer">
%endif
		<string name="anim-idle">idle 8</string>
		<string name="anim-walk">walk 8</string>
		<string name="anim-dash">dash 8</string>
		
		
		<dict name="evade-effect">
			<string name="class">SpawnSelfEffect</string>
			<vec3 name="pos-jitter">10 10 0</vec3>
			<float name="dir-spread">360</float>
			<float name="speed">0.8</float>
			<int name="ttl">250</int>
			<int name="copies">4</int>
			<string name="color-start">#505050A0</string>
			<string name="color-end">#6060F000</string>
		</dict>
		
		
		<dict name="footsteps">
			<int name="delay">100</int>
			<int name="feet-distance">4</int>
		</dict>
		<dict name="footsteps-dash">
			<int name="delay">30</int>
			<int name="feet-distance">0</int>
		</dict>
	</behavior>
	
	
	<scenes start="shared">
		<scene name="base">
			<minimap_sprite origin="4 4" layer="210" texture="gui/minimap.png" frame="0 56 8 8" />
			<scene src="special/shadow.unit:13"/>
			<effect src="./player_light.effect"/>
		</scene>
		<scene name="shared-charge">
			<scene src="base" />
			<collision bullet="true" static="false">
				<circle offset="-0.5 -1" radius="5.5" density="3" shoot-through="false" charging="true" />
			</collision>
		</scene>
		<scene name="shared">
			<scene src="base" />
			<collision bullet="true" static="false">
				<circle offset="-0.5 -1" radius="5.5" density="10" charge-through="true" aim-through="true" />
			</collision>
		</scene>		
	</scenes>
</unit>
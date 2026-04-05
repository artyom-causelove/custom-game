const dotaRoot = getDotaRoot();
const dotaHud = dotaRoot.FindChildTraverse('portraitHUD');

let portraits = null;

GameEvents.Subscribe('portraits_init', data => {
  const array = Object.values(data);
  portraits = array.map(item => ({
    ...item,
    element: $.CreatePanel('DOTAScenePanel', dotaHud, '', {
      map: `portraits/npc_dota_hero_knight_rookie`,
      light: 'light',
      camera: 'camera',
      antialias: true,
      particleonly: false,
      rendershadows: true,
      deferredalpha: true,
      renderdeferred: false,
      renderwaterreflections: false,
      class: 'portrait-item',
      style: `
        width: 500px;
        height: 500px;
      `
    })
  }));
});

GameEvents.Subscribe('portraits_update', data => {
  const portrait = portraits.find(item => item.player_id === data.player_id);
  portrait.camera = data.camera;
});

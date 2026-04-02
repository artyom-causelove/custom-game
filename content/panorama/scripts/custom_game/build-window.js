const root = $.GetContextPanel();

let selectedBuilding = 'none';
let buildingPanels = [];
let activePanel = null;
let currentCampId = null;
let lastCampId = null;

const [wrapper] = root.FindChildrenWithClassTraverse('build-window-wrapper');
const [itemWrapper] = root.FindChildrenWithClassTraverse('item-wrapper');
const [closeButton] = root.FindChildrenWithClassTraverse('close-button');
const [acceptButton] = root.FindChildrenWithClassTraverse('accept-button');

const resetState = force => {
  acceptButton?.RemoveClass('active');
  activePanel?.RemoveClass('active');
  acceptButton.enabled = false;
  selectedBuilding = 'none';
  buildingPanels = [];
  activePanel = null;
  itemWrapper.RemoveAndDeleteChildren();

  if (force) {
    currentCampId = null;
    lastCampId = null;
    return;
  }

  $.Schedule(10, () => {
    currentCampId = null;
    lastCampId = null;
  });
};

// Логика работы кнопки 'Подтвердить'
acceptButton.enabled = false;
acceptButton.SetPanelEvent('onactivate', () => {
  if (!acceptButton.enabled) return;

  const eventName = 'custom_building_picked';
  const event = { campId: currentCampId, buildingName: selectedBuilding };
  GameEvents.SendCustomGameEventToServer(eventName, event);
  $.Msg(`Event from PanoramaUI (${eventName}): ${JSON.stringify(event)}`);

  resetState();
  wrapper.AddClass('hidden');
});

// Логика работы кнопки 'Закрыть'
closeButton.SetPanelEvent('onactivate', () => {
  resetState();
  wrapper.AddClass('hidden');
});

// Логика работы кнопок зданий
const itemOnClick = element => {
  return () => {
    if (element.buildingName === 'none') return;

    if (activePanel && activePanel !== element) {
      activePanel.RemoveClass('active');
    }

    activePanel = element;
    selectedBuilding = element.buildingName;
    acceptButton.AddClass('active');
    activePanel.AddClass('active');
    acceptButton.enabled = true;
  }
};

// Логика появления окна 
// event: Array<{
//   class: string
//   title: string
//   image: string
//   price: number
//   description: string
// }>
GameEvents.Subscribe('custom_building_window_show', event => {
  if (event.campId === currentCampId) return;
  if (event.campId === lastCampId) return;

  const buildings = Object.values(event.buildings);
  resetState(true);
  currentCampId = event.campId;
  lastCampId = event.campId;

  buildingPanels = buildings.map(building => {
    const snippet = $.CreatePanel('Panel', itemWrapper, '');
    snippet.BLoadLayoutSnippet('build-item');

    const buttonItem = snippet.GetChild(0);
    const image = buttonItem.GetChild(0);
    const title = buttonItem.GetChild(1);
    const goldText = buttonItem.GetChild(2).GetChild(1);

    buttonItem.buildingName = building.class;
    image.SetImage(building.image);
    title.text = building.title;
    goldText.text = building.price;

    buttonItem.SetPanelEvent('onactivate', itemOnClick(buttonItem));
    buttonItem.SetPanelEvent('onmouseover', () => 
      $.DispatchEvent('DOTAShowTextTooltip', buttonItem, building.description)
    );
    buttonItem.SetPanelEvent('onmouseout', () => 
      $.DispatchEvent('DOTAHideTextTooltip')
    );

    return snippet;
  });

  wrapper.RemoveClass('hidden');
});

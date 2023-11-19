import Codeware.UI.*
import GpsMinimap.Math.GetAnchorPoint

/////////////////////////////////////////////////////////////////
@addField(QuestTrackerGameController)
private let m_im_resolutionWatcher: ref<VirtualResolutionWatcher>;

@addField(QuestTrackerGameController)
private let m_im_baseCanvas: ref<inkCanvas>;

@addField(QuestTrackerGameController)
private let m_im_lastMinimapState: Bool;

/////////////////////////////////////////////////////////////////
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
    // Set up movable base parent widget
    let rootWidget: ref<inkCompoundWidget> = GameInstance.GetInkSystem().GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let customBaseCanvas: ref<inkCanvas> = new inkCanvas();

    customBaseCanvas.Reparent(rootWidget);

    this.m_im_baseCanvas = customBaseCanvas;

    // Set up resolution watcher
    let resolutionWatcher = new VirtualResolutionWatcher();
    watcher.Initialize(GetGameInstance());
    watcher.NotifyController(this);

    this.m_im_resolutionWatcher = resolutionWatcher;

    return wrappedMethod();
}

/////////////////////////////////////////////////////////////////
@addMethod(QuestTrackerGameController)
protected cb func OnMinimapToggle(isMinimapHidden: Bool) {
    // Calculate anchor point based on screen size
    let screenSize = ScreenHelper.GetScreenSize(GetGameInstance());
    let anchorPoint = new Vector2(0.0, 0.0); 

    if (isMinimapHidden) {
      anchorPoint = GetAnchorPoint(screenSize, QuestWidget_Corner.GetCoefficient(), QuestWidget_Corner.GetOffset());
    }
    else {
      anchorPoint = GetAnchorPoint(screenSize, QuestWidget_Default.GetCoefficient(), QuestWidget_Default.GetOffset());
    }

    // Apply changes to vanilla widget
    let vanillaWidget: ref<inkCompoundWidget> = this.GetRootCompoundWidget();

    vanillaWidget.SetAnchor(inkEAnchor.Centered);
    vanillaWidget.Reparent(this.m_im_baseCanvas);
    vanillaWidget.SetAnchorPoint(anchorPoint);

    this.m_im_lastMinimapState = isMinimapHidden;
}

@addMethod(QuestTrackerGameController)
protected cb func OnResolutionChange(evt: ref<VirtualResolutionChangeEvent>) {
    this.OnMinimapToggle(this.m_im_lastMinimapState);
}
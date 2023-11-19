import Codeware.UI.*

native func LogChannel(channel: CName, const text: script_ref<String>) //CDPR apparently removed this in 2.0?

public func debugLayers() {
    let inkSystem = GameInstance.GetInkSystem();
    let layers = inkSystem.GetLayers();

    for layer in layers {
        LogChannel(n"DEBUG", s"UI Layer: \(layer.GetLayerName()) \(layer.GetGameController().GetClassName())");
        for controller in layer.GetGameControllers() {
            let widgetSelection: ref<inkCompoundWidget> = controller.GetRootCompoundWidget();
            LogChannel(n"DEBUG", s"Game Controller: \(controller.GetClassName())");
            LogChannel(n"DEBUG", s"Children: \(widgetSelection.GetNumChildren())");
            //LogChannel(n"DEBUG", s"Scale: \(Codeware.Version()) \(widgetSelection.GetSize()) \(widgetSelection.GetAnchorPoint())");
        }
    }
}

public func initializeResolutionWatcher() {

    let system = GameInstance.GetInkSystem();
    let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let layers = system.GetLayers();
    for layer in layers {
        for controller in layer.GetGameControllers() {
            if controller.IsA(n"QuestTrackerGameController") {
                let watcherControllerDummy: ref<inkCustomController>;
                let m_controller: ref<inkGameController> = controller as inkGameController;
                watcherControllerDummy.SetGameController(m_controller);
                watcherControllerDummy.Reparent(root);
                let watcher = new VirtualResolutionWatcher();
                watcher.Initialize(GetGameInstance());
                watcher.NotifyController(watcherControllerDummy);
            }
        }
    }

}

public func questTrackerMoveCorner() {
    let system = GameInstance.GetInkSystem();
    let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let layers = system.GetLayers();

    let m_resolutionListener: ref<VirtualResolutionWatcher> = new VirtualResolutionWatcher();
    m_resolutionListener.Initialize(GetGameInstance());
    
    for layer in layers {
        for controller in layer.GetGameControllers() {
            if controller.IsA(n"QuestTrackerGameController") {
                let questWidgetCustom: ref<inkCanvas> = new inkCanvas();
                let questWidgetBase: ref<inkCompoundWidget> = controller.GetRootCompoundWidget();
                questWidgetCustom.Reparent(root);
                m_resolutionListener.ScaleWidget(controller.GetRootWidget());                
                questWidgetBase.SetAnchor(inkEAnchor.Centered);
                
                questWidgetBase.Reparent(questWidgetCustom);
                
                //the worst scaling solution you have ever seen
                let m_screenSize = ScreenHelper.GetScreenSize(GetGameInstance());
                let screenWidth: Float = m_screenSize.X;
                let screenHeight: Float = m_screenSize.Y;
                let anchorX: Float = CalculateNewAnchorPoint(screenWidth, -0.001295, 0.5694);   //coef -0.001295, offset 0.5694
                let anchorY: Float = CalculateNewAnchorPoint(screenHeight, -0.000338, 0.021);    //coef -0.000338, offset 0.021
                questWidgetBase.SetAnchorPoint(anchorX, anchorY);

                //questWidgetBase.SetAnchorPoint(-4.4, -0.71); //functional value for 4k
                //questWidgetBase.SetAnchorPoint(-1.917, -0.344); //functional value for 1080p
                //questWidgetBase.SetAnchorPoint(-1.092, -0.224); //functional value for 720p
                //m_resolutionListener.SendEventToAllControllers();
                //m_resolutionListener.NotifyController(controller.GetController());
            }           
        }
    }
}

public func questTrackerMoveDefault() {
    let system = GameInstance.GetInkSystem();
    let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let layers = system.GetLayers();

    let m_resolutionListener: ref<VirtualResolutionWatcher> = new VirtualResolutionWatcher();
    m_resolutionListener.Initialize(GetGameInstance());
    
    for layer in layers {
        for controller in layer.GetGameControllers() {
            if controller.IsA(n"QuestTrackerGameController") {
                let questWidgetCustom: ref<inkCanvas> = new inkCanvas();
                let questWidgetBase: ref<inkCompoundWidget> = controller.GetRootCompoundWidget();
                questWidgetCustom.Reparent(root);
                m_resolutionListener.ScaleWidget(controller.GetRootWidget());                
                questWidgetBase.SetAnchor(inkEAnchor.Centered);
                
                questWidgetBase.Reparent(questWidgetCustom);

                //the worst scaling solution you have ever seen
                let m_screenSize = ScreenHelper.GetScreenSize(GetGameInstance());
                let screenWidth: Float = m_screenSize.X;
                let screenHeight: Float = m_screenSize.Y;
                let anchorX: Float = CalculateNewAnchorPoint(screenWidth, -0.001295, 0.5694);   //coef -0.001295, offset 0.5694 | Same as above
                let anchorY: Float = CalculateNewAnchorPoint(screenHeight, -0.001794, 0.02);    //coef -0.001794, offset 0.02
                questWidgetBase.SetAnchorPoint(anchorX, anchorY);

                //questWidgetBase.SetAnchorPoint(-4.4, -3.858); //functional value for 4k
                //questWidgetBase.SetAnchorPoint(-1.917, -1.917); //functional value for 1080p
                //questWidgetBase.SetAnchorPoint(-1.092, -1.275); //functional value for 720p
            }           
        }
    }
}

//Making this slightly less messy
private func CalculateNewAnchorPoint(xy: Float, coef: Float, offset: Float) -> Float {
    let output: Float;
    output = (xy * coef) + offset;
    return output;
}

//Not working atm
protected cb func OnResolutionChange(evt: ref<VirtualResolutionChangeEvent>) {
    LogChannel(n"DEBUG", s"Resolution change detected!");
}

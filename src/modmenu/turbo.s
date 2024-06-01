# TODO: Better descriptions/complete parameter list....

/**========================================================================
 ** MARK:           AudAudioPlayer_setupTotalMasterVolume_
 *?  Changes the game volume (background music and sound effects) from DRC
 *?  and TV.
 *@param1 r3, "AudAudioPlayer", address
 *@param2 f1, "volume", float
 *========================================================================**/
AudAudioPlayer_setupTotalMasterVolume_:
	GOTO_GLUE_FUNC "audio::AudAudioPlayer::setupTotalMasterVolume_"

/**========================================================================
 ** MARK:            AudAudioPlayer_setupBgmMasterVolume_
 *?  Changes the game volume (background music) from DRC and TV.
 *@param1 r3, "AudAudioPlayer", address
 *@param2 f1, "volume", float
 *========================================================================**/
AudAudioPlayer_setupBgmMasterVolume_:
	GOTO_GLUE_FUNC "audio::AudAudioPlayer::setupBgmMasterVolume_"

/**========================================================================
 ** MARK:            AudAudioPlayer_setupSeMasterVolume_
 *?  Changes the game volume (background music) from DRC and TV.
 *@param1 r3, "AudAudioPlayer", address
 *@param2 f1, "volume", float
 *========================================================================**/
AudAudioPlayer_setupSeMasterVolume_:
	GOTO_GLUE_FUNC "audio::AudAudioPlayer::setupSeMasterVolume_"

/**========================================================================
 ** MARK:                      utl_startSound2D
 *?  Starts a 2D sound effect.
 *@param1 r3, "utf-8 string (name)", address
 *========================================================================**/
utl_startSound2D:
	GOTO_GLUE_FUNC "audio::utl::startSound2D"

/**========================================================================
 ** MARK:                      Sector_GetSector
 *?  Returns a pointer to a specific checkpoint data.
 *@param1 r3, "checkpoint ID", address
 *@return r3, "checkpoint", address
 *========================================================================**/
Sector_GetSector:
	GOTO_GLUE_FUNC "object::Sector_GetSector"

/**========================================================================
 ** MARK:               FieldSubMeshCulling_setEnable
 *?  Enables/disables map culling.
 *@param1 r3, "CourseInfo + 0x44", address
 *@param2 r4, "enable", bool
 *========================================================================**/
FieldSubMeshCulling_setEnable:
	GOTO_GLUE_FUNC "object::FieldSubMeshCulling::setEnable"

/**========================================================================
 ** MARK:                     FUN_GetMinItemTime
 *?  
 *@return r3, "min time", unsigned int
 *========================================================================**/
FUN_GetMinItemTime:
	GOTO_GLUE_FUNC "FUN_0E2B03F8"

/**========================================================================
 ** MARK:                   ItemOwnerProxy_isKeep
 *?  Checks whether a player is holding an item on hand.
 *@param1 r3, "ItemOwner", address
 *@return r3, "isKeep", bool
 *========================================================================**/
ItemOwnerProxy_isKeep:
	GOTO_GLUE_FUNC "object::ItemOwnerProxy::isKeep"

/**========================================================================
 ** MARK:                 ItemOwnerProxy_isThrowing
 *?  Checks whether a player is throwing an item.
 *@param1 r3, "ItemOwner", address
 *@return r3, "isThrowing", bool
 *========================================================================**/
ItemOwnerProxy_isThrowing:
	GOTO_GLUE_FUNC "object::ItemOwnerProxy::isThrowing"

/**========================================================================
 ** MARK:               ItemOwnerProxy__clearItemSlot
 *?  Clears the item roulette.
 *@param1 r3, "ItemOwner", address
 *========================================================================**/
ItemOwnerProxy__clearItemSlot:
	GOTO_GLUE_FUNC "object::ItemOwnerProxy::_clearItemSlot"

/**========================================================================
 ** MARK:                ItemOwnerProxy_setItemForce
 *?  Forces a player to receive an item.
 *@param1 r3, "ItemOwner", address
 *@param2 r4, "item ID", address
 *========================================================================**/
ItemOwnerProxy_setItemForce:
	GOTO_GLUE_FUNC "object::ItemOwnerProxy::setItemForce"

/**========================================================================
 ** MARK:                       FUN_DropItems
 *?  Drops items of a player (if not on hand) on the ground.
 *@param1 r3, "ItemOwner", address
 *========================================================================**/
FUN_DropItems:
	GOTO_GLUE_FUNC "FUN_0E2E47E4"

/**========================================================================
 ** MARK:                  KartCollision_checkKart_
 *?  Checks if a kart has collided with another kart.
 *@param1 r3, "Kart1Collision", address
 *@param2 r4, "unknown", address
 *@param3 r5, "Kart2Collision", address
 *@return r4, "kartCollided", bool
 *========================================================================**/
KartCollision_checkKart_:
	GOTO_GLUE_FUNC "object::KartCollision::checkKart_"

/**========================================================================
 ** MARK:                 KartInfoProxy_getKartUnit
 *?  Converts a player ID to a memory address pointing to player data.
 *@param3 r3, "player ID", unsigned int
 *@return r3, "KartUnit", address
 *========================================================================**/
KartInfoProxy_getKartUnit:
	GOTO_GLUE_FUNC "object::KartInfoProxy::getKartUnit"

/**========================================================================
 ** MARK:                    KartInfoProxy_isGoal
 *?  Checks whether a kart has finished all laps.
 *@param3 r3, "KartUnit", address
 *@return r3, "isGoal", bool
 *========================================================================**/
KartInfoProxy_isGoal:
	GOTO_GLUE_FUNC "object::KartInfoProxy::isGoal"

/**========================================================================
 ** MARK:                   KartInfoProxy_isAerial
 *?  Checks whether a kart is suspended in the air.
 *@param3 r3, "KartUnit", address
 *@return r3, "isAerial", bool
 *========================================================================**/
KartInfoProxy_isAerial:
	GOTO_GLUE_FUNC "object::KartInfoProxy::isAerial"

/**========================================================================
 ** MARK:                  KartInfoProxy_isAccident
 *?  Returns true if the kart was hit by something.
 *@param1 r3, "KartUnit", address
 *@return r3, "isAccident", bool
 *========================================================================**/
KartInfoProxy_isAccident:
	GOTO_GLUE_FUNC "object::KartInfoProxy::isAccident"

/**========================================================================
 ** MARK:                   KartInfoProxy_isInStar
 *?  Returns true if the kart has star powerup.
 *@param1 r3, "KartUnit", address
 *@return r3, "isInStar", bool
 *========================================================================**/
KartInfoProxy_isInStar:
	GOTO_GLUE_FUNC "object::KartInfoProxy::isInStar"

/**========================================================================
 ** MARK:                   KartInfoProxy_isKiller
 *?  Returns true if the kart is in bullet bill state.
 *@param1 r3, "KartUnit", address
 *@return r3, "isKiller", bool
 *========================================================================**/
KartInfoProxy_isKiller:
	GOTO_GLUE_FUNC "object::KartInfoProxy::isKiller"

/**========================================================================
 ** MARK:                 KartInfoProxy_isJugemHang
 *?  Returns true if the kart is being picked up by lakitu.
 *@param1 r3, "KartUnit", address
 *@return r3, "isJugemHang", bool
 *========================================================================**/
KartInfoProxy_isJugemHang:
	GOTO_GLUE_FUNC "object::KartInfoProxy::isJugemHang"

/**========================================================================
 ** MARK:              KartJugemRecover_updateFinalMtx_
 *?  Updates the respawn destination matrix.
 *@param1 r3, "KartJugemRecover", address
 *@param2 r4, "unknown", unknown
 *========================================================================**/
KartJugemRecover_updateFinalMtx_:
	GOTO_GLUE_FUNC "object::KartJugemRecover::updateFinalMtx_"

/**========================================================================
 ** MARK:              S_KartJugemRecover_startRecover
 *?  Forces a kart to be picked up by lakitu.
 *@param1 r3, "KartJugemRecover", address
 *========================================================================**/
.equiv "S_KartJugemRecover_startRecover_Ptr", "object::KartJugemRecover::startRecover" + 0x4
S_KartJugemRecover_startRecover:
	li r4, 0
	li r5, 0
	stwu r1, -0x20 (r1)
	GOTO_GLUE_FUNC "S_KartJugemRecover_startRecover_Ptr"

/**========================================================================
 ** MARK:                     FUN_finishRecover
 *?  Instantly places a kart on a respawn point when respawning.
 *@param1 r3, "KartJugemRecover", address
 *@param2 r4, "enable", bool
 *========================================================================**/
FUN_finishRecover:
	GOTO_GLUE_FUNC "FUN_0E3193C8"

/**========================================================================
 ** MARK:               KartVehicle_forceClearAccident
 *?  Clears the current kart animation when hitting something.
 *@param1 r3, "KartUnit", address
 *========================================================================**/
KartVehicle_forceClearAccident:
	GOTO_GLUE_FUNC "object::KartVehicle::forceClearAccident"

/**========================================================================
 ** MARK:            KartVehicleControl_getRaceController
 *?  Returns a pointer to race controller values.
 *@param1 r3, "KartUnit", address
 *@return r3, "RaceController", address
 *========================================================================**/
KartVehicleControl_getRaceController:
	GOTO_GLUE_FUNC "object::KartVehicleControl::getRaceController"

/**========================================================================
 ** MARK:                  KartVehicleMove_setSpeed
 *?  Forces a kart to reach a certain speed.
 *@param1 r3, "KartUnit", address
 *@param2 f1, "speed", float
 *========================================================================**/
KartVehicleMove_setSpeed:
	GOTO_GLUE_FUNC "object::KartVehicleMove::setSpeed"

/**========================================================================
 ** MARK:                 KartVehicleMove_forceStop
 *?  Freezes a kart in place.
 *@param1 r3, "KartUnit", address
 *========================================================================**/
KartVehicleMove_forceStop:
	GOTO_GLUE_FUNC "object::KartVehicleMove::forceStop"

/**========================================================================
 ** MARK:                    FUN_setItemBoxForce
 *?  Forces a player to receive an item box.
 *@param1 r3, <unused>
 *@param2 r4, "KartUnit", address
 *========================================================================**/
FUN_setItemBoxForce:
	GOTO_GLUE_FUNC "FUN_0E47913C"

/**========================================================================
 ** MARK:                RaceCheckerBase_forceGoalAll
 *?  Ends a race.
 *========================================================================**/
RaceCheckerBase_forceGoalAll:
	GOTO_GLUE_FUNC "object::RaceCheckerBase::forceGoalAll"

/**========================================================================
 ** MARK:                        IsRaceState
 *?  Returns true if the race has started.
 *@return r3, "IsRaceState", bool
 *========================================================================**/
IsRaceState:
	GOTO_GLUE_FUNC "object::IsRaceState"

/**========================================================================
 ** MARK:                 RaceIndex__DRCPlayer2Kart
 *?  Returns the player ID corresponding to the Wii U GamePad Player.
 *@return r3, "DRCPlayer", unsigned int
 *========================================================================**/
RaceIndex__DRCPlayer2Kart:
	GOTO_GLUE_FUNC "object::RaceIndex_::DRCPlayer2Kart"

/**========================================================================
 ** MARK:                 RaceController_startRumble
 *?  Starts a controller's rumble.
 *@param1 r3, "RaceController", address
 *@param2 r4, "Rumble Pattern ID", address
 *========================================================================**/
RaceController_startRumble:
	GOTO_GLUE_FUNC "sys::RaceController::startRumble"

/**========================================================================
 ** MARK:                   RenderEngine_getEngine
 *?  Fetches the render engine.
 *@return r3, "RenderEngine", address
 *========================================================================**/
RenderEngine_getEngine:
	GOTO_GLUE_FUNC "render::RenderEngine::getEngine"

/**========================================================================
 ** MARK:        ControllerManager_setAllRaceControllerPause
 *?  Stop reading race controller inputs.
 *@param1 r3, "SystemEngine", address
 *@param2 r4, "unknown", unsigned int
 *@param3 r5, "pause", bool
 *========================================================================**/
ControllerManager_setAllRaceControllerPause:
	GOTO_GLUE_FUNC "sys::ControllerManager::setAllRaceControllerPause"

/**========================================================================
 ** MARK:                   SystemEngine_getEngine
 *?  Fetches the system engine.
 *@return r3, "SystemEngine", address
 *========================================================================**/
SystemEngine_getEngine:
	GOTO_GLUE_FUNC "sys::SystemEngine::getEngine"

/**========================================================================
 ** MARK:                   ProcessManager_lockHBM
 *?  Attempts to disable the home menu button.
 *@return r3, "ProcessManager", address
 *========================================================================**/
ProcessManager_lockHBM:
	GOTO_GLUE_FUNC "sys::ProcessManager::lockHBM"

/**========================================================================
 ** MARK:                  ProcessManager_unlockHBM
 *?  Attempts to enable the home menu button.
 *@return r3, "ProcessManager", address
 *========================================================================**/
ProcessManager_unlockHBM:
	GOTO_GLUE_FUNC "sys::ProcessManager::unlockHBM"

/**========================================================================
 ** MARK:                SaveDataManager_saveUserData
 *?  Saves a user's data.
 *@param1 r3, "SystemEngine", address
 *========================================================================**/
SaveDataManager_saveUserData:
	GOTO_GLUE_FUNC "sys::SaveDataManager::saveUserData"

/**========================================================================
 ** MARK:             SaveDataManager_getUserSaveDataPtr
 *?  Returns a pointer to user save data.
 *@param1 r3, "SystemEngine", address
 *@param2 r4, "unknown", unsigned int
 *@return r3, "SaveData", address
 *========================================================================**/
SaveDataManager_getUserSaveDataPtr:
	GOTO_GLUE_FUNC "sys::SaveDataManager::getUserSaveDataPtr"

/**========================================================================
 ** MARK:                     UIControl_findPane
 *?  Searches UI data by its ID and returns a pointer.
 *@param1 r3, "UIData", address
 *@param2 r4, "args", address
 *========================================================================**/
UIControl_findPane:
	GOTO_GLUE_FUNC "ui::UIControl::findPane"

/**========================================================================
 ** MARK:                         GetDialog
 *?  Returns a pointer to the dialog box UI element.
 *@return r3, "dialog", address
 *========================================================================**/
GetDialog:
	GOTO_GLUE_FUNC "ui::GetDialog"

/**========================================================================
 ** MARK:                           GetBg
 *?  Returns a pointer to the menu background UI element.
 *@return r3, "background", address
 *========================================================================**/
GetBg:
	GOTO_GLUE_FUNC "ui::GetBg"

/**========================================================================
 ** MARK:                  RegisterScalableFontText
 *?  Prints text to ui. (utf-16 encoded string, null terminated)
 *@param1 r3, "string", address
 *@param2 r4, "ui element", address
 *@param3 r5, "unknown", int
 *@param4 r6, "unknown", bool
 *========================================================================**/
RegisterScalableFontText:
	GOTO_GLUE_FUNC "ui::RegisterScalableFontText"

/**========================================================================
 ** MARK:           Menu3DModelDirector_pushInformCommand
 *?  Runs the UI planet background.
 *@param1 r3, "Menu3DModelDirector", address
 *========================================================================**/
Menu3DModelDirector_pushInformCommand:
	GOTO_GLUE_FUNC "object::Menu3DModelDirector::pushInformCommand"

/**========================================================================
 ** MARK:       Menu3DModelEarth_forceApplyColorCorrectionBase
 *?  Applies color correction to the WiFi UI background.
 *@param1 r3, "Menu3DModelEarth", address
 *========================================================================**/
Menu3DModelEarth_forceApplyColorCorrectionBase:
	GOTO_GLUE_FUNC "object::Menu3DModelEarth::forceApplyColorCorrectionBase"

/**========================================================================
 ** MARK:                       Page_Dialog_in
 *?  Opens an empty dialog box.
 *@param1 r3, "dialog", address
 *========================================================================**/
Page_Dialog_in_:
	GOTO_GLUE_FUNC "ui::Page_Dialog::in_"

/**========================================================================
 ** MARK:                     Page_Dialog_close
 *?  Closes a dialog box.
 *@param1 r3, "dialog", address
 *========================================================================**/
Page_Dialog_close:
	GOTO_GLUE_FUNC "ui::Page_Dialog::close"

/**========================================================================
 ** MARK:                    Page_Dialog_isClose
 *?  Returns true if a dialog box is closed.
 *@param1 r3, "dialog", address
 *@return r3, "isClose", bool
 *========================================================================**/
Page_Dialog_isClose:
	GOTO_GLUE_FUNC "ui::Page_Dialog::isClose"

/**========================================================================
 ** MARK:                    Page_Bg_animKeepWiFi
 *?  Prepares the WiFi UI background element.
 *@param1 r3, "background", address
 *========================================================================**/
Page_Bg_animKeepWiFi:
	GOTO_GLUE_FUNC "ui::Page_Bg::animKeepWiFi"

/**========================================================================
 ** MARK:               Control_RaceDRC_setPushButton
 *?  Required to call other functions like:
 *?  "ui::Control_RaceDRC::forceSetFullScreen"
 *@param1 r3, "Control_RaceDRC", address
 *@param r4, "unknown", unknown
 *@param r5, "unknown", unknown
 *@param r6, "unknown", unknown
 *========================================================================**/
Control_RaceDRC_setPushButton:
	GOTO_GLUE_FUNC "ui::Control_RaceDRC::setPushButton"

/**========================================================================
 ** MARK:             Control_RaceDRC_forceSetFullScreen
 *?  Forces the copy of the TV screen on the Wii U GamePad to fullscreen
 *@param1 r3, "Control_RaceDRC", address
 *========================================================================**/
Control_RaceDRC_forceSetFullScreen:
	GOTO_GLUE_FUNC "ui::Control_RaceDRC::forceSetFullScreen"

/**========================================================================
 ** MARK:                      ASM_VEC_Distance
 *?  Calculates the distance between 2 objects.
 *@param1 r3, "3D vector", address
 *@param2 r4, "3D vector", address
 *========================================================================**/
ASM_VEC_Distance:
	GOTO_GLUE_FUNC "ASM_VECDistance"

/**========================================================================
 ** MARK:               ControllerMgr_getControlDevice
 *?  Returns a pointer to a buffer containing controller data.
 *@param1 r3, "ControllerMgr", address
 *@param2 r4, "controller type", unsigned int
 *@return r3, "controller data buffer" address
 *========================================================================**/
ControllerMgr_getControlDevice:
	GOTO_GLUE_FUNC "sead::ControllerMgr::getControlDevice"

/**========================================================================
 ** MARK:                    SystemTask_pauseDraw
 *?  Pauses and resumes graphics rendering.
 *@param1 r3, "SystemTask", address
 *@param2 r4, "isPause", boolean
 *========================================================================**/
SystemTask_pauseDraw:
	GOTO_GLUE_FUNC "gsys::SystemTask::pauseDraw"

/**========================================================================
 ** MARK:                        StringStream
 *?  Creates a string buffer (unicode) to perform various string operations.
 *@param1 r3, "string stream", address
 *@return r3, "string stream", address
 *========================================================================**/
StringStream:
	GOTO_GLUE_FUNC "nn::nex::StringStream::StringStream"

/**========================================================================
 ** MARK:                 StringStream_InsertString
 *?  Inserts a string into a unicode string buffer. Similar to C++ cout <<.
 *@param1 r3, "string stream", address
 *@param2 r4, "unicode string", address
 *@return r3, "string stream", address
 *========================================================================**/
StringStream_InsertString:
	GOTO_GLUE_FUNC "nn::nex::StringStream::operator<<"

/**========================================================================
 ** MARK:                    DestroyStringStream
 *?  Destroys a unicode string buffer created by StringStream.
 *@param1 r3, "string stream", address
 *@param2 r4, "unknown", unsigned int
 *========================================================================**/
DestroyStringStream:
	GOTO_GLUE_FUNC "nn::nex::StringStream::~StringStream"

/**========================================================================
 ** MARK:                       DestroyString
 *?  Destroys a string buffer.
 *@param1 r3, "unicode string buffer output", address
 *@param2 r4, "unknown", unsigned int
 *========================================================================**/
DestroyString:
	GOTO_GLUE_FUNC "nn::nex::String::~String"

/**========================================================================
 ** MARK:                           String
 *?  Creates a string buffer where converted unicode characters are stored.
 *@param1 r3, "unicode string buffer output", address
 *@param2 r4, "utf-8 string", address
 *@return r3, "unicode string buffer output", address
 *========================================================================**/
String:
	GOTO_GLUE_FUNC "nn::nex::String::String"

/**========================================================================
 ** MARK:                      GetRandomNumber
 *?  Generates a random integer value between 0 and a value defined by GPR3
 *?  (Result is greater than or equal to 0 and lower than GPR3)
 *@param1 r3, "Max val", unsigned int
 *@return r3, "random", unsigned int
 *========================================================================**/
GetRandomNumber:
	GOTO_GLUE_FUNC "nn::nex::Platform::GetRandomNumber"

/**========================================================================
 ** MARK:                       StringToUpper
 *?  Converts a unicode formatted string (null terminated) to uppercase
 *?  characters. The result is stored back into the input buffer.
 *@param1 r3, "unicode string buffer output", address
 *@return r3, "unicode string buffer output", address
 *========================================================================**/
StringToUpper:
	GOTO_GLUE_FUNC "nn::nex::String::ToUpper"

/**========================================================================
 ** MARK:                          wcs_len
 *?  https://devdocs.io/c/string/wide/wcslen
 *@param1 r3, "src", address
 *========================================================================**/
wcs_len:
	GOTO_GLUE_FUNC "wcslen"

/**========================================================================
 ** MARK:                         sw_printf
 *?  https://devdocs.io/c/io/fwprintf
 *@param1 r3, "string buffer", address
 *@param2 r4, "buffer size", unsigned int
 *@param3 r5, "string", address
 *@param rX, "format", any
 *@. . .
 *========================================================================**/
sw_printf:
	GOTO_GLUE_FUNC "swprintf"

/**========================================================================
 ** MARK:                          str_cpy
 *?  https://devdocs.io/c/string/byte/strcpy
 *@param1 r3, "target", address
 *@param2 r4, "src", address
 *========================================================================**/
str_cpy:
	GOTO_GLUE_FUNC "__ghs_strcpy"

/**========================================================================
 ** MARK:                         mem_alloc
 *?  https://devdocs.io/c/memory/malloc
 *@param1 r3, "size", unsigned int
 *@return r3, "allocated memory", address
 *========================================================================**/
mem_alloc:
	GOTO_GLUE_FUNC "malloc"

/**========================================================================
 ** MARK:                          mem_free
 *?  https://devdocs.io/c/memory/free
 *@param1 r3, "allocated memory", address
 *========================================================================**/
mem_free:
	GOTO_GLUE_FUNC "free"

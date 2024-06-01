	EXPORT_ADDR "ModMenu_Tools_Aimbot_", "Player1Target, Player2Target, Player3Target, Player4Target"
	EXPORT_ADDR "ModMenu_Tools_SuperItemWheel_", "P1ItemSel, P1InputLock, P2ItemSel, P2InputLock, P3ItemSel, P3InputLock, P4ItemSel, P4InputLock, IsEnabled"
	EXPORT_ADDR "ModMenu_Tools_CamFOVPatch_CalcFov_", "P1BtnF, P2BtnF, P3BtnF, P4BtnF, P5BtnF, P6BtnF, P7BtnF, P8BtnF, P9BtnF, P10BtnF, P11BtnF, P12BtnF"
	EXPORT_ADDR "ModMenu_SoundAndVisuals_RGBWorld_", "Flag, DefaultR, DefaultG, DefaultB"
	EXPORT_ADDR "ModMenu_Tools_TouchFreefly_", "OldX, OldY"

/**========================================================================
 ** MARK:                    ModMenu_Tools_Aimbot
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_Aimbot:
	STACK_FRAME 0x24
	stmw r23, 0x8 (r1)

	SET_ADDR r31, "addr_ModMenu_Tools_Aimbot_Player1Target"

	cmpwi r3, 0
	bne ModMenu_Tools_Aimbot_Enable

ModMenu_Tools_Aimbot_ClearAllFindKart:
	li r0, 0
	stw r0, 0 (r31)
	stw r0, 0x4 (r31)
	stw r0, 0x8 (r31)
	stw r0, 0xC (r31)
	b ModMenu_Tools_Aimbot_Exit

ModMenu_Tools_Aimbot_Enable:
	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq- ModMenu_Tools_Aimbot_ClearAllFindKart

	LOAD_ADDR r12, "addr_AudSceneBase"
	lwz r12, 0xF0 (r12)
	addi r30, r12, 0x70
	lwz r29, 0x98 (r12)
	lwz r28, 0x94 (r12)
	cmpwi r29, 0
	ble- ModMenu_Tools_Aimbot_ClearAllFindKart
	mr r27, r28
	li r26, 0

ModMenu_Tools_Aimbot_TryApply:
	lwzu r3, 0x4 (r30)
	bl KartInfoProxy_getKartUnit
	mr r24, r3

	lwz r12, 0x4 (r24)
	lbz r0, 0x66 (r12)
	cmpwi r0, 0
	bne ModMenu_Tools_Aimbot_ClearFindKart

	lwz r12, 0x14 (r24)
	lwz r3, 0x20C (r12)
	bl KartInfoProxy_isJugemHang
	cmpwi r3, 0
	bne ModMenu_Tools_Aimbot_ClearFindKart

	lwz r23, 0 (r31)
	cmpwi r23, 0
	bne ModMenu_Tools_Aimbot_Apply

ModMenu_Tools_Aimbot_TryFindKart:
	mr r3, r26
	bl KartInfoProxy_getKartUnit
	mr r23, r3
	lwz r12, 0x4 (r23)
	lwz r11, 0x4 (r24)

	lwz r5, 0x50 (r12)
	lwz r6, 0x50 (r11)
	cmpw r5, r6
	beq ModMenu_Tools_Aimbot_TryFindNextKart

	lwz r3, 0x24 (r12)
	addi r4, r3, 0x48
	lwz r5, 0x24 (r11)
	bl KartCollision_checkKart_
	cmpwi r3, 0
	beq ModMenu_Tools_Aimbot_TryFindNextKart
	stw r23, 0 (r31)

	SET_ADDR r3, "s_SE_SYS_VoiceChatStart"
	bl utl_startSound2D
	b ModMenu_Tools_Aimbot_Apply

ModMenu_Tools_Aimbot_TryFindNextKart:
	addi r26, r26, 0x1
	subic. r28, r28, 0x1
	bne ModMenu_Tools_Aimbot_TryFindKart
	b ModMenu_Tools_Aimbot_TryApplyNext

ModMenu_Tools_Aimbot_Apply:
	lwz r12, 0x4 (r24)
	lwz r12, 0x14 (r12)
	lwz r23, 0x4 (r23)
	lwz r23, 0x14 (r23)

	addi r3, r12, 0x24
	addi r4, r23, 0x24
	bl ASM_VEC_Distance

	LOAD_FLOAT_U f0, "const_ModMenu_Aimbot_Parameters" (r11)
	fcmpu cr0, f1, f0
	blt ModMenu_Tools_Aimbot_StopKartAndApplyNext

	lfs f0, 0x4 (r11)
	fcmpu cr0, f1, f0
	bge ModMenu_Tools_Aimbot_CancelApply

	lwz r12, 0x4 (r24)
	lwz r12, 0x14 (r12)
	lfs f5, 0x24 (r12)
	lfs f6, 0x28 (r12)
	lfs f7, 0x2C (r12)
	lfs f8, 0x24 (r23)
	lfs f9, 0x28 (r23)
	lfs f10, 0x2C (r23)

	fsubs f5, f8, f5
	fsubs f6, f9, f6
	fsubs f7, f10, f7

	fdivs f8, f5, f1
	fdivs f9, f6, f1
	fdivs f10, f7, f1

	lfs f0, 0x8 (r11)
	fcmpu cr0, f8, f0
	ble ModMenu_Tools_Aimbot_TryApplyNext
	fcmpu cr0, f9, f0
	ble ModMenu_Tools_Aimbot_TryApplyNext
	fcmpu cr0, f10, f0
	ble ModMenu_Tools_Aimbot_TryApplyNext
	stfs f8, 0x270 (r12)
	stfs f8, 0x27C (r12)
	stfs f8, 0x288 (r12)
	stfs f9, 0x274 (r12)
	stfs f9, 0x280 (r12)
	stfs f9, 0x28C (r12)
	stfs f10, 0x278 (r12)
	stfs f10, 0x284 (r12)
	stfs f10, 0x290 (r12)
	b ModMenu_Tools_Aimbot_TryApplyNext

ModMenu_Tools_Aimbot_CancelApply:
	lwz r12, 0x4 (r24)
	lwz r3, 0x8 (r12)
	bl KartVehicleControl_getRaceController

	li r0, 0x1
	stw r0, 0x8 (r1)
	addi r4, r1, 0x8
	LOAD_FLOAT f1, "const_NULL" (r12)
	bl RaceController_startRumble

	SET_ADDR r3, "s_SE_SYS_VoiceChatEnd"
	bl utl_startSound2D

ModMenu_Tools_Aimbot_ClearFindKart:
	li r0, 0
	stw r0, 0 (r31)
	b ModMenu_Tools_Aimbot_TryApplyNext

ModMenu_Tools_Aimbot_StopKartAndApplyNext:
	mr r3, r24
	lfs f1, 0x8 (r12)
	bl KartVehicleMove_setSpeed

ModMenu_Tools_Aimbot_TryApplyNext:
	li r26, 0
	mr r28, r27
	subic. r29, r29, 0x1
	addi r31, r31, 0x4
	bne ModMenu_Tools_Aimbot_TryApply

ModMenu_Tools_Aimbot_Exit:
	lmw r23, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                 ModMenu_Tools_BulletKiller
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_BulletKiller:
	STACK_FRAME 0x18
	stmw r27, 0xC (r1)

	cmpwi r3, 0
	beq ModMenu_Tools_BulletKiller_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, 0
	beq ModMenu_Tools_BulletKiller_Exit

	LOAD_ADDR r12, "addr_AudSceneBase"
	lwz r12, 0xF0 (r12)
	addi r31, r12, 0x70
	lwz r30, 0x98 (r12)
	cmpwi r30, 0
	ble ModMenu_Tools_RespawnAtWill_Exit

	LOAD_ADDR r29, "addr_RaceDirector"
	lwz r29, 0x28 (r29)
	lwz r29, 0x4 (r29)
	lwz r29, 0x30 (r29)
	addi r29, r29, 0xC

ModMenu_Tools_BulletKiller_TryApply:
	lwzu r3, 0x4 (r31)
	bl KartInfoProxy_getKartUnit
	lwz r28, 0x4 (r3)

	lwz r12, 0x14 (r3)
	lwz r3, 0x20C (r12)
	bl KartInfoProxy_isJugemHang
	cmpwi r3, 0
	bne ModMenu_Tools_BulletKiller_TryApplyNext

	lwz r0, 0xFC (r28)
	clrlwi r0, r0, 30
	cmpwi r0, 0x3
	bne ModMenu_Tools_BulletKiller_TryApplyNext

	lwz r3, 0x8 (r28)
	bl KartVehicleControl_getRaceController

	lwz r5, 0x1A4 (r3)
	rlwinm. r0, r5, 20, 31, 31
	beq ModMenu_Tools_BulletKiller_TryApplyNext

	lwz r3, 0x14 (r28)
	bl KartVehicleMove_forceStop

	lwz r3, 0x14 (r28)
	lfs f1, 0x3B8 (r3)
	bl KartVehicleMove_setSpeed

	lwz r0, 0 (r31)
	mulli r0, r0, 0x6C

	lwzx r11, r29, r0
	stw r11, 0x8 (r1)

	addi r3, r1, 0x8
	bl Sector_GetSector
	mr r27, r3

	lwz r3, 0x3C (r27)
	bl GetRandomNumber
	slwi r0, r3, 2

	lwz r12, 0x40 (r27)
	lwzx r12, r12, r0
	lfs f5, 0x74 (r12)
	lfs f6, 0x78 (r12)
	lfs f7, 0x7C (r12)
	lfs f8, 0x8C (r12)
	lfs f9, 0x90 (r12)
	lfs f10, 0x94 (r12)

	lwz r12, 0x14 (r28)
	stfs f5, 0x24 (r12)
	stfs f6, 0x28 (r12)
	stfs f7, 0x2C (r12)
	stfs f8, 0x270 (r12)
	stfs f8, 0x27C (r12)
	stfs f8, 0x288 (r12)
	stfs f9, 0x274 (r12)
	stfs f9, 0x280 (r12)
	stfs f9, 0x28C (r12)
	stfs f10, 0x278 (r12)
	stfs f10, 0x284 (r12)
	stfs f10, 0x290 (r12)

ModMenu_Tools_BulletKiller_TryApplyNext:
	subic. r30, r30, 0x1
	bne ModMenu_Tools_BulletKiller_TryApply

ModMenu_Tools_BulletKiller_Exit:
	lmw r27, 0xC (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                   ModMenu_Tools_Moonjump
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_Moonjump:
	cmpwi r3, 0
	lis r3, "object::KartVehicleMove::calcMove" + 0x98@ha
	lwzu r0, "object::KartVehicleMove::calcMove" + 0x98@l (r3)
	bne ModMenu_Tools_Moonjump_Enable

	lis r4, 0x3861
	ori r4, r4, 0x8
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_Tools_Moonjump_Enable:
	SET_PATCH_ADDR r4, "ModMenu_Tools_MoonjumpPatch_CalcGravity"
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_Tools_MoonjumpPatch_CalcGravity:
	STACK_FRAME

	bl ModMenu_isRaceReady
	cmpwi r3, 0
	beq ModMenu_Tools_MoonjumpPatch_CalcGravity_Exit

	LOAD_ADDR r12, "addr_AudSceneBase"
	lwz r12, 0xF0 (r12)
	addi r5, r12, 0x70
	lwz r6, 0x98 (r12)
	cmpwi r6, 0
	ble ModMenu_Tools_MoonjumpPatch_CalcGravity_Exit

ModMenu_Tools_MoonjumpPatch_CalcGravity_TryApply:
	lwzu r3, 0x4 (r5)
	bl KartInfoProxy_getKartUnit
	lwz r7, 0x4 (r3)

	lwz r8, 0x14 (r7)
	cmpw r8, r30
	bne ModMenu_Tools_MoonjumpPatch_CalcGravity_TryApplyNext

	lwz r0, 0xFC (r7)
	rlwinm. r0, r0, 29, 31, 31
	beq ModMenu_Tools_MoonjumpPatch_CalcGravity_TryApplyNext

	lwz r12, 0x14 (r3)
	lwz r3, 0x20C (r12)
	bl KartInfoProxy_isAerial
	cmpwi r3, 0
	bne ModMenu_Tools_MoonjumpPatch_CalcGravity_Apply

	lwz r12, 0xEC (r8)
	lwz r0, 0x8 (r12)
	cmpwi r0, 0
	bne ModMenu_Tools_MoonjumpPatch_CalcGravity_TryApplyNext

ModMenu_Tools_MoonjumpPatch_CalcGravity_Apply:
	lfs f5, 0x238 (r30)
	fneg f5, f5
	stfs f5, 0x238 (r30)

ModMenu_Tools_MoonjumpPatch_CalcGravity_TryApplyNext:
	subic. r6, r6, 0x1
	bne ModMenu_Tools_MoonjumpPatch_CalcGravity_TryApply

ModMenu_Tools_MoonjumpPatch_CalcGravity_Exit:
	addi r3, r1, 0x10 # Expected register value.
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_Tools_RespawnAtWill
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_RespawnAtWill:
	STACK_FRAME 0xC
	stmw r29, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_Tools_RespawnAtWill_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_Tools_RespawnAtWill_Exit

	LOAD_ADDR r12, "addr_AudSceneBase"
	lwz r12, 0xF0 (r12)
	addi r31, r12, 0x70
	lwz r30, 0x98 (r12)
	cmpwi r30, 0
	ble ModMenu_Tools_RespawnAtWill_Exit

ModMenu_Tools_RespawnAtWill_TryApply:
	lwzu r3, 0x4 (r31)
	bl KartInfoProxy_getKartUnit
	lwz r29, 0x4 (r3)

	lwz r3, 0x8 (r29)
	bl KartVehicleControl_getRaceController

	lbz r0, 0x1A4 (r3)
	cmpwi r0, 0x1
	bne ModMenu_Tools_RespawnAtWill_TryApplyNext

	lwz r3, 0x4C (r29)
	bl S_KartJugemRecover_startRecover

ModMenu_Tools_RespawnAtWill_TryApplyNext:
	subic. r30, r30, 0x1
	bne ModMenu_Tools_RespawnAtWill_TryApply

ModMenu_Tools_RespawnAtWill_Exit:
	lmw r29, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_Tools_SuperItemWheel
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_SuperItemWheel:
	STACK_FRAME 0x18
	stmw r26, 0x8 (r1)

	SET_ADDR r31, "addr_ModMenu_Tools_SuperItemWheel_P1ItemSel"

	cmpwi r3, 0
	lis r3, "object::ItemDirector::calcKeyInput_EachPlayer_" + 0x104@ha
	lwzu r0, "object::ItemDirector::calcKeyInput_EachPlayer_" + 0x104@l (r3)
	bne ModMenu_Tools_SuperItemWheel_Enable

	lis r4, 0x4807
	ori r4, r4, 0xAAB5
	cmpw r4, r0
	bnel- InstructionPatcher

ModMenu_Tools_SuperItemWheel_ResetIDFlags:
	mr r3, r31
	li r4, 0
	li r5, 0x24
	bl OSBlockSet
	b ModMenu_Tools_SuperItemWheel_Exit

ModMenu_Tools_SuperItemWheel_Enable:
	lis r4, 0x3860
	cmpw r4, r0
	bnel- InstructionPatcher

	li r0, true
	stb r0, 0x20 (r31)

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq- ModMenu_Tools_SuperItemWheel_ResetIDFlags

	LOAD_ADDR r12, "addr_AudSceneBase"
	lwz r12, 0xF0 (r12)
	addi r30, r12, 0x70
	lwz r29, 0x98 (r12)
	cmpwi r29, 0
	ble- ModMenu_Tools_SuperItemWheel_ResetIDFlags

ModMenu_Tools_SuperItemWheel_TryApply:
	lwzu r3, 0x4 (r30)
	bl KartInfoProxy_getKartUnit
	mr r28, r3

	lwz r3, 0x4 (r28)
	lwz r3, 0x8 (r3)
	bl KartVehicleControl_getRaceController

	li r27, 0
	lwz r5, 0x1A4 (r3)
	lwz r6, 0x4 (r31)
	rlwinm. r0, r5, 20, 31, 31
	beq ModMenu_Tools_SuperItemWheel_SetInputLock

	rlwinm. r0, r5, 14, 31, 31
	bne ModMenu_Tools_SuperItemWheel_SetPrevItem
	rlwinm. r0, r5, 13, 31, 31
	bne ModMenu_Tools_SuperItemWheel_SetNextItem

ModMenu_Tools_SuperItemWheel_SetInputLock:
	stw r27, 0x4 (r31)
	b ModMenu_Tools_SuperItemWheel_CalcSetItem

ModMenu_Tools_SuperItemWheel_SetPrevItem:
	cmpwi r6, 0
	bne ModMenu_Tools_SuperItemWheel_CalcSetItem
	li r27, -1
	b ModMenu_Tools_SuperItemWheel_SetInputLock

ModMenu_Tools_SuperItemWheel_SetNextItem:
	cmpwi r6, 0
	bne ModMenu_Tools_SuperItemWheel_CalcSetItem
	li r27, 1
	b ModMenu_Tools_SuperItemWheel_SetInputLock

ModMenu_Tools_SuperItemWheel_CalcSetItem:
	mr r3, r28
	bl ModMenu_KartUnit_isAvailableCatch
	mr r26, r3

	cmpwi r27, 0
	beq ModMenu_Tools_SuperItemWheel_UpdateItem

	SET_ADDR r3, "s_SE_SYS_SLOT_FRAME"
	bl utl_startSound2D

	lwz r7, 0 (r31)
	add r27, r7, r27
	cmplwi r27, 0x14
	ble ModMenu_Tools_SuperItemWheel_SetItem

	xori r27, r7, 0x14

ModMenu_Tools_SuperItemWheel_SetItem:
	stw r27, 0 (r31)

	lwz r12, 0xC (r28)
	lwz r3, 0x5C (r12)
	bl FUN_DropItems

	lwz r12, 0xC (r28)
	lwz r3, 0x5C (r12)
	bl ItemOwnerProxy__clearItemSlot

ModMenu_Tools_SuperItemWheel_UpdateItem:
	cmpwi r26, 0
	beq ModMenu_Tools_SuperItemWheel_TryApplyNext

	lwz r12, 0xC (r28)
	lwz r3, 0x5C (r12)
	mr r4, r31
	bl ItemOwnerProxy_setItemForce

ModMenu_Tools_SuperItemWheel_TryApplyNext:
	subic. r29, r29, 0x1
	addi r31, r31, 0x8
	bne ModMenu_Tools_SuperItemWheel_TryApply

ModMenu_Tools_SuperItemWheel_Exit:
	lmw r26, 0x8 (r1)
	isync
	RETURN_SEQ

/**========================================================================
 ** MARK:                    ModMenu_Tools_CamFOV
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_CamFOV:
	STACK_FRAME

	cmpwi r3, 0
	lis r3, "object::KartCamera::calcFovy" + 0x25C@ha
	lwzu r0, "object::KartCamera::calcFovy" + 0x25C@l (r3)
	bne ModMenu_Tools_CamFOV_Enable

	lis r4, 0xFC40
	ori r4, r4, 0xD090
	cmpw r4, r0
	beq ModMenu_Tools_CamFOV_Exit

	bl InstructionPatcher

	SET_ADDR r3, "addr_ModMenu_Tools_CamFOVPatch_CalcFov_P1BtnF"
	li r4, 0
	li r5, 0x4 * 12
	bl OSBlockSet

	b ModMenu_Tools_CamFOV_Exit

ModMenu_Tools_CamFOV_Enable:
	SET_PATCH_ADDR r4, "ModMenu_Tools_CamFOVPatch_CalcFov"
	cmpw r4, r0
	bnel- InstructionPatcher

ModMenu_Tools_CamFOV_Exit:
	RETURN_SEQ

ModMenu_Tools_CamFOVPatch_CalcFov:
	STACK_FRAME 0x10
	stmw r28, 0x8 (r1)

	SET_ADDR r31, "addr_ModMenu_Tools_CamFOVPatch_CalcFov_P1BtnF"

	LOAD_ADDR r12, "addr_RaceDirector"
	cmpwi r12, 0
	beq ModMenu_Tools_CamFOVPatch_CalcFov_Exit
	lwz r30, 0x1CC (r12)
	cmpwi r30, 0
	ble ModMenu_Tools_CamFOVPatch_CalcFov_Exit
	li r29, 0

ModMenu_Tools_CamFOVPatch_CalcFov_TryApply:
	lwz r12, 0x8 (r1)
	lwz r12, 0x94 (r12)
	lwz r12, 0x4 (r12)
	lwz r0, 0x50 (r12)
	cmpw r0, r29
	bne ModMenu_Tools_CamFOVPatch_CalcFov_TryApplyNext

	slwi r11, r29, 2
	add r28, r31, r11

	lwz r3, 0x8 (r12)
	bl KartVehicleControl_getRaceController
	lwz r5, 0x1A4 (r3)
	lbz r6, 0 (r28)

	rlwinm. r0, r5, 20, 31, 31
	beq ModMenu_Tools_CamFOVPatch_CalcFov_ResetFlag

	lhz r7, 0x2 (r28)
	subic. r7, r7, 0x1
	bge+ ModMenu_Tools_CamFOVPatch_CalcFov_AttemptNewFOV
	sth r7, 0x2 (r28)

	xori r6, r6, 0x1
	stb r6, 0 (r28)

	SET_ADDR r3, "s_SE_SYS_CHAT_ON"
	bl utl_startSound2D
	b ModMenu_Tools_CamFOVPatch_CalcFov_TryApplyNext

ModMenu_Tools_CamFOVPatch_CalcFov_ResetFlag:
	li r0, 0
	sth r0, 0x2 (r28)

ModMenu_Tools_CamFOVPatch_CalcFov_AttemptNewFOV:
	cmpwi r6, 0
	beq ModMenu_Tools_CamFOVPatch_CalcFov_Exit

	LOAD_FLOAT f5, "const_ModMenu_Tools_CamFOVPatch_Modifier" (r12)
	fadds f26, f26, f5
	b ModMenu_Tools_CamFOVPatch_CalcFov_Exit

ModMenu_Tools_CamFOVPatch_CalcFov_TryApplyNext:
	addi r29, r29, 0x1
	subic. r30, r30, 0x1
	bne ModMenu_Tools_CamFOVPatch_CalcFov_TryApply

ModMenu_Tools_CamFOVPatch_CalcFov_Exit:
	fmr f2, f26 # Original Instruction
	lmw r28, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                 ModMenu_Tools_TouchFreefly
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_Tools_TouchFreefly:
	STACK_FRAME 0x14
	stmw r27, 0x8 (r1)

	SET_ADDR r31, "addr_ModMenu_Tools_TouchFreefly_OldX"

	cmpwi r3, 0
	bne ModMenu_Tools_TouchFreefly_Enable
	
ModMenu_Tools_TouchFreefly_ClearOldCoordinates:
	li r0, 0
	stw r0, 0 (r31)
	stw r0, 0x4 (r31)
	b ModMenu_Tools_TouchFreefly_Exit

ModMenu_Tools_TouchFreefly_Enable:
	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq- ModMenu_Tools_TouchFreefly_ClearOldCoordinates

	bl RaceIndex__DRCPlayer2Kart
	cmplwi r3, 0xB
	bgt- ModMenu_Tools_TouchFreefly_ClearOldCoordinates

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r12, 0x28 (r12)
	lwz r12, 0x4 (r12)
	lwz r12, 0x30 (r12)
	mulli r0, r3, 0x6C
	add r30, r12, r0

	bl KartInfoProxy_getKartUnit
	mr r29, r3

	lwz r3, 0x14 (r29)
	lwz r3, 0x20C (r3)
	bl KartInfoProxy_isJugemHang
	cmpwi r3, 0
	bne- ModMenu_Tools_TouchFreefly_ClearOldCoordinates

	lwz r3, 0x4 (r29)
	lwz r3, 0x8 (r3)
	bl KartVehicleControl_getRaceController
	mr r28, r3

	LOAD_ADDR r12, "addr_UIEngine"
	lwz r12, 0x10 (r12)
	lwz r12, 0x4 (r12)
	lwz r12, 0x1A0 (r12)
	lwz r3, 0x2BC (r12)
	mr. r27, r3
	beq- ModMenu_Tools_TouchFreefly_ClearOldCoordinates
	li r4, 0
	li r5, 0
	li r6, 1
	bl Control_RaceDRC_setPushButton

	mr r3, r27
	bl Control_RaceDRC_forceSetFullScreen

	lwz r5, 0x1A4 (r28)
	rlwinm. r5, r5, 17, 31, 31
	beq- ModMenu_Tools_TouchFreefly_ClearOldCoordinates

	lwz r3, 0x4 (r29)
	lwz r3, 0x14 (r3)
	bl KartVehicleMove_forceStop

	lfs f5, 0x114 (r28) # Current touch coordinates
	lfs f6, 0x110 (r28) # Current touch coordinates

	lfs f7, 0 (r31) # Frame old touch coordinates
	lfs f8, 0x4 (r31) # Frame old touch coordinates

	stfs f5, 0 (r31)
	stfs f6, 0x4 (r31)

	LOAD_FLOAT f0, "const_NULL" (r12)
	fadds f13, f7, f8

	fcmpu cr0, f0, f13
	beq ModMenu_Tools_TouchFreefly_Exit

	fsubs f5, f7, f5
	fsubs f6, f6, f8

	LOAD_FLOAT_U f0, "ModMenu_Tools_TouchFreefly_Parameters" (r12)

	fmuls f5, f5, f0
	fmuls f6, f6, f0

	lwz r11, 0x4 (r29)
	lwz r11, 0x14 (r11)
	lfs f7, 0x24 (r11)
	lfs f8, 0x2C (r11)

	fadds f5, f7, f5
	fadds f6, f8, f6
	lfs f7, 0x4 (r12)
	lfs f8, 0x8 (r12)

	stfs f5, 0x24 (r11)
	stfs f6, 0x2C (r11)
	stfs f7, 0x270 (r11)
	stfs f7, 0x27C (r11)
	stfs f7, 0x288 (r11)
	stfs f8, 0x274 (r11)
	stfs f8, 0x280 (r11)
	stfs f8, 0x28C (r11)
	stfs f8, 0x278 (r11)
	stfs f8, 0x284 (r11)
	stfs f8, 0x290 (r11)

	fneg f7, f7
	stfs f8, 0x3C (r30)
	stfs f7, 0x40 (r30)
	stfs f8, 0x44 (r30)
	stfs f8, 0x48 (r30)
	stfs f7, 0x4C (r30)
	stfs f8, 0x50 (r30)

ModMenu_Tools_TouchFreefly_Exit:
	lmw r27, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:              ModMenu_SoundAndVisuals_BgMusic
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_BgMusic:
	STACK_FRAME

	mr r5, r3

	LOAD_ADDR r12, "addr_AudioMgr"
	cmpwi r12, NULL
	beq ModMenu_SoundAndVisuals_BgMusic_Exit
	lwz r3, 0x1C (r12)

	cmpwi r5, 0
	bne ModMenu_SoundAndVisuals_BgMusic_Default

	LOAD_FLOAT f1, "const_NULL" (r12)
	b ModMenu_SoundAndVisuals_BgMusic_Apply

ModMenu_SoundAndVisuals_BgMusic_Default:
	lfs f1, 0x21C (r3)

ModMenu_SoundAndVisuals_BgMusic_Apply:
	bl AudAudioPlayer_setupBgmMasterVolume_

ModMenu_SoundAndVisuals_BgMusic_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_SoundAndVisuals_SFX
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_SFX:
	STACK_FRAME

	mr r5, r3

	LOAD_ADDR r12, "addr_AudioMgr"
	cmpwi r12, NULL
	beq ModMenu_SoundAndVisuals_SFX_Exit
	lwz r3, 0x1C (r12)

	cmpwi r5, 0
	bne ModMenu_SoundAndVisuals_SFX_Default

	LOAD_FLOAT f1, "const_NULL" (r12)
	b ModMenu_SoundAndVisuals_SFX_Apply

ModMenu_SoundAndVisuals_SFX_Default:
	lfs f1, 0x220 (r3)

ModMenu_SoundAndVisuals_SFX_Apply:
	bl AudAudioPlayer_setupSeMasterVolume_

ModMenu_SoundAndVisuals_SFX_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:              ModMenu_SoundAndVisuals_VCLimit
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_VCLimit:
	STACK_FRAME

	cmpwi r3, 0
	bne ModMenu_SoundAndVisuals_VCLimit_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_SoundAndVisuals_VCLimit_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r5, 0x1CC (r12)
	cmpwi r5, 0
	ble ModMenu_SoundAndVisuals_VCLimit_Exit
	li r6, 0

ModMenu_SoundAndVisuals_VCLimit_TryApply:
	mr r3, r6
	bl KartInfoProxy_getKartUnit
	lwz r12, 0x14 (r3)

	li r0, -1
	stw r0, 0x27C (r12)

ModMenu_SoundAndVisuals_VCLimit_TryApplyNext:
	addi r6, r6, 0x1
	subic. r5, r5, 0x1
	bne ModMenu_SoundAndVisuals_VCLimit_TryApply

ModMenu_SoundAndVisuals_VCLimit_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_SoundAndVisuals_MuteBullet
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_MuteBullet:
	cmpwi r3, 0
	lis r3, "audio::AudSoundObjKart::updateCurParam" + 0x114@ha
	lwzu r0, "audio::AudSoundObjKart::updateCurParam" + 0x114@l (r3)
	bne ModMenu_SoundAndVisuals_MuteBullet_Enable

	lis r4, 0x4812
	ori r4, r4, 0x853D
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_SoundAndVisuals_MuteBullet_Enable:
	lis r4, 0x3860
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:              ModMenu_SoundAndVisuals_MuteStar
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_MuteStar:
	cmpwi r3, 0
	lis r3, "audio::AudSoundObjKart::updateCurParam" + 0xD0@ha
	lwzu r0, "audio::AudSoundObjKart::updateCurParam" + 0xD0@l (r3)
	bne ModMenu_SoundAndVisuals_MuteStar_Enable

	lis r4, 0x4812
	ori r4, r4, 0x84FD
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_SoundAndVisuals_MuteStar_Enable:
	lis r4, 0x3860
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:            ModMenu_SoundAndVisuals_LightningFX
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_LightningFX:
	STACK_FRAME

	cmpwi r3, 0
	beq ModMenu_SoundAndVisuals_LightningFX_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_SoundAndVisuals_LightningFX_Exit

	LOAD_ADDR r12, "addr_CourseInfo"
	li r0, 0x1
	stb r0, 0x2B3 (r12)

	LOAD_FLOAT f5, "const_ModMenu_SoundAndVisuals_LightningFX_Intensity" (r11)
	li r5, 0x5A
	stw r5, 0x2B4 (r12)
	stfs f5, 0x2B8 (r12)

ModMenu_SoundAndVisuals_LightningFX_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:              ModMenu_SoundAndVisuals_ScreenFX
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_ScreenFX:
	cmpwi r3, 0
	lis r3, "object::KartScreenEffect::calcAll"@ha
	lwzu r0, "object::KartScreenEffect::calcAll"@l (r3)
	bne ModMenu_SoundAndVisuals_ScreenFX_Enable

	lis r4, 0x6000
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_SoundAndVisuals_ScreenFX_Enable:
	lis r4, 0x4BFF
	ori r4, r4, 0xFFA4
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:                ModMenu_SoundAndVisuals_Bloom
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_Bloom:
	cmpwi r3, 0
	lis r3, "gsys::ModelScenePfx::isBloomEnabled" + 0x60@ha
	lwzu r0, "gsys::ModelScenePfx::isBloomEnabled" + 0x60@l (r3)
	bne ModMenu_SoundAndVisuals_Bloom_Enable

	lis r4, 0x3860
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_SoundAndVisuals_Bloom_Enable:
	lis r4, 0x54C3
	ori r4, r4, 0x63E
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:              ModMenu_SoundAndVisuals_RGBWorld
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SoundAndVisuals_RGBWorld:
	STACK_FRAME

	lis r12, "addr_ModMenu_SoundAndVisuals_RGBWorld_Flag"@ha
	lbzu r0, "addr_ModMenu_SoundAndVisuals_RGBWorld_Flag"@l (r12)

	LOAD_ADDR r11, "addr_RaceDirector"
	cmpwi r11, NULL
	beq ModMenu_SoundAndVisuals_RGBWorld_ResetDefaultsFlag
	lwz r11, 0x328 (r11)
	cmpwi r11, NULL
	beq ModMenu_SoundAndVisuals_RGBWorld_ResetDefaultsFlag
	lwz r11, 0xA4 (r11)
	cmpwi r11, NULL
	beq ModMenu_SoundAndVisuals_RGBWorld_ResetDefaultsFlag
	lis r5, 0
	ori r5, r5, 0xA300
	lwzx r11, r11, r5
	cmpwi r11, NULL
	beq ModMenu_SoundAndVisuals_RGBWorld_ResetDefaultsFlag
	lwz r11, 0 (r11)
	cmpwi r11, NULL
	beq ModMenu_SoundAndVisuals_RGBWorld_ResetDefaultsFlag

	cmpwi r3, 0
	beq ModMenu_SoundAndVisuals_RGBWorld_TryRestoreDefaults

	cmpwi r0, 0
	bne ModMenu_SoundAndVisuals_RGBWorld_Update

	li r0, 0x1
	stb r0, 0 (r12)

	SET_ADDR r3, "addr_ModMenu_SoundAndVisuals_RGBWorld_DefaultR"
	addi r4, r11, 0xB4
	li r5, 0xC
	li r6, 0
	bl OSBlockMove

	b ModMenu_SoundAndVisuals_RGBWorld_Exit

ModMenu_SoundAndVisuals_RGBWorld_Update:
	addi r3, r11, 0xB4
	SET_ADDR r4, "addr_ModMenu_GenericRGBCycler_RedVector"
	li r5, 0xC
	li r6, 1
	bl OSBlockMove

	b ModMenu_SoundAndVisuals_RGBWorld_Exit

ModMenu_SoundAndVisuals_RGBWorld_TryRestoreDefaults:
	cmpwi r0, 0
	beq ModMenu_SoundAndVisuals_RGBWorld_Exit

	li r0, 0
	stb r0, 0 (r12)

	addi r3, r11, 0xB4
	SET_ADDR r4, "addr_ModMenu_SoundAndVisuals_RGBWorld_DefaultR"
	li r5, 0xC
	li r6, 0
	bl OSBlockMove

	b ModMenu_SoundAndVisuals_RGBWorld_Exit

ModMenu_SoundAndVisuals_RGBWorld_ResetDefaultsFlag:
	li r0, 0
	stb r0, 0 (r12)

ModMenu_SoundAndVisuals_RGBWorld_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_WorldSettings_AntiG
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_WorldSettings_AntiG:
	cmpwi r3, 0
	lis r3, "object::LapRankChecker3D::updateGravityDir_" + 0x120@ha
	lwzu r0, "object::LapRankChecker3D::updateGravityDir_" + 0x120@l (r3)
	bne ModMenu_WorldSettings_AntiG_Enable

	lis r4, 0x3860
	ori r4, r4, 0xFFFF
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_WorldSettings_AntiG_Enable:
	lis r4, 0x4BCB
	ori r4, r4, 0x34F5
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:              ModMenu_WorldSettings_Boundaries
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_WorldSettings_Boundaries:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	mr. r31, r3
	lis r3, "object::KartDirector::calcKarts" + 0x23C@ha
	lwzu r0, "object::KartDirector::calcKarts" + 0x23C@l (r3)
	bne ModMenu_WorldSettings_Boundaries_TryEnable

	lis r4, 0x6000
	cmpw r4, r0
	beq ModMenu_WorldSettings_Boundaries_UpdateCulling
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::startRecover"@h
	ori r3, r3, "object::KartJugemRecover::startRecover"@l
	lis r4, 0x4E80
	ori r4, r4, 0x20
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::calcCheckOnRoad" + 0xBC@h
	ori r3, r3, "object::KartJugemRecover::calcCheckOnRoad" + 0xBC@l
	lis r4, 0x6000
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x15C@h
	ori r3, r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x15C@l
	lis r4, 0x6000
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x198@h
	ori r3, r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x198@l
	lis r4, 0x6000
	bl InstructionPatcher

	lis r3, "FUN_0E316F8C" + 0x84@h
	ori r3, r3, "FUN_0E316F8C" + 0x84@l
	lis r4, 0x6000
	bl InstructionPatcher

	b ModMenu_WorldSettings_Boundaries_UpdateCulling

ModMenu_WorldSettings_Boundaries_TryEnable:
	lis r4, 0x4080
	ori r4, r4, 0x10
	cmpw r4, r0
	beq ModMenu_WorldSettings_Boundaries_UpdateCulling
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::startRecover"@h
	ori r3, r3, "object::KartJugemRecover::startRecover"@l
	lis r4, 0x9421
	ori r4, r4, 0xFFE0
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::calcCheckOnRoad" + 0xBC@h
	ori r3, r3, "object::KartJugemRecover::calcCheckOnRoad" + 0xBC@l
	lis r4, 0x4834
	ori r4, r4, 0xDC1D
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x15C@h
	ori r3, r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x15C@l
	lis r4, 0x4834
	ori r4, r4, 0xDB7D
	bl InstructionPatcher

	lis r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x198@h
	ori r3, r3, "object::KartJugemRecover::calcCheckOnRoad" + 0x198@l
	lis r4, 0x4834
	ori r4, r4, 0xDB41
	bl InstructionPatcher

	lis r3, "FUN_0E316F8C" + 0x84@h
	ori r3, r3, "FUN_0E316F8C" + 0x84@l
	lis r4, 0x4834
	ori r4, r4, 0xCC71
	bl InstructionPatcher

ModMenu_WorldSettings_Boundaries_UpdateCulling:
	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_WorldSettings_Boundaries_Exit

	LOAD_ADDR r12, "addr_CourseInfo"
	lwz r3, 0x44 (r12)
	lbz r0, 0 (r3)
	cmpw r0, r31
	beq ModMenu_WorldSettings_Boundaries_Exit

	mr r4, r31
	bl FieldSubMeshCulling_setEnable

ModMenu_WorldSettings_Boundaries_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:               ModMenu_WorldSettings_OffRoad
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_WorldSettings_OffRoad:
	cmpwi r3, 0
	lis r3, "FUN_0E353E70" + 0x4C@ha
	lwzu r0, "FUN_0E353E70" + 0x4C@l (r3)
	bne ModMenu_WorldSettings_OffRoad_Enable

	lis r4, 0x38A0
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_WorldSettings_OffRoad_Enable:
	lis r4, 0x80BF
	ori r4, r4, 0x01E0
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:               ModMenu_WorldSettings_WallCol
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_WorldSettings_WallCol:
	cmpwi r3, 0
	lis r3, "object::KartVehicleMove::calcCollisionWall"@ha
	lwzu r0, "object::KartVehicleMove::calcCollisionWall"@l (r3)
	bne ModMenu_WorldSettings_WallCol_Enable

	lis r4, 0x4E80
	ori r4, r4, 0x20
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_WorldSettings_WallCol_Enable:
	lis r4, 0x7C08
	ori r4, r4, 0x2A6
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:             ModMenu_WorldSettings_WaterEngine
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_WorldSettings_WaterEngine:
	cmpwi r3, 0
	lis r3, "object::KartVehicle::checkUnderWater" + 0x70@ha
	lwzu r0, "object::KartVehicle::checkUnderWater" + 0x70@l (r3)
	lis r4, 0xC1AC
	bne ModMenu_WorldSettings_WaterEngine_Enable

	ori r4, r4, 0x2658
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_WorldSettings_WaterEngine_Enable:
	ori r4, r4, 0xF7F8
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:            ModMenu_RaceSettings_AllowBackDrive
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_RaceSettings_AllowBackDrive:
	cmpwi r3, 0
	beqlr

	LOAD_ADDR r12, "addr_RaceDirector"
	cmpwi r12, NULL
	beqlr
	lwz r11, 0x1CC (r12)
	cmpwi r11, 0
	blelr

	lwz r12, 0x28 (r12)
	cmpwi r12, NULL
	beqlr

	lwz r12, 0x4 (r12)
	cmpwi r12, NULL
	beqlr

	lwz r12, 0x30 (r12)
	cmpwi r12, NULL
	beqlr

	mtctr r11

ModMenu_RaceSettings_AllowBackDrive_Apply:
	li r6, 0
	lhz r7, 0xA (r12)
	clrrwi r0, r7, 1
	sth r0, 0xA (r12)
	stw r6, 0x64 (r12)

	addi r12, r12, 0x6C
	bdnz ModMenu_RaceSettings_AllowBackDrive_Apply
	blr

/**========================================================================
 ** MARK:              ModMenu_RaceSettings_CPUPlayers
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_RaceSettings_CPUPlayers:
	STACK_FRAME

	mr r5, r3

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_RaceSettings_CPUPlayers_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r6, 0x1CC (r12)
	cmpwi r6, 0
	ble ModMenu_RaceSettings_CPUPlayers_Exit
	li r7, 0

ModMenu_RaceSettings_CPUPlayers_TryApply:
	mr r3, r7
	bl KartInfoProxy_getKartUnit
	lwz r12, 0x4 (r3)
	lbz r0, 0x66 (r12)
	cmpwi r0, 0
	beq ModMenu_RaceSettings_CPUPlayers_TryApplyNext

	stb r5, 0x67 (r12)

ModMenu_RaceSettings_CPUPlayers_TryApplyNext:
	addi r7, r7, 0x1
	subic. r6, r6, 0x1
	bne ModMenu_RaceSettings_CPUPlayers_TryApply

ModMenu_RaceSettings_CPUPlayers_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:              ModMenu_RaceSettings_FinishRace
 *@param1 r3, "isEnabled", bool
 *@param2 r4, "page id", unsigned int
 *@param3 r5, "page item id", unsigned int
 *========================================================================**/
ModMenu_RaceSettings_FinishRace:
	STACK_FRAME

	cmpwi r3, 0
	beq ModMenu_RaceSettings_FinishRace_Exit

	LOAD_ADDR r3, "addr_ModMenu_DialogPage_PageArray"
	bl ModMenu_DialogPageSelector_GetItem
	lbz r0, 0xF (r3)
	clrrwi r0, r0, 1
	stb r0, 0xF (r3)

	bl ModMenu_DialogBox_RequestClose

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_RaceSettings_FinishRace_Exit

	bl RaceCheckerBase_forceGoalAll

ModMenu_RaceSettings_FinishRace_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:              ModMenu_RaceSettings_LapProgress
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_RaceSettings_LapProgress:
	cmpwi r3, 0
	lis r3, "object::LapRankChecker3D::updateLapCheck_"@ha
	lwzu r0, "object::LapRankChecker3D::updateLapCheck_"@l (r3)
	bne ModMenu_RaceSettings_LapProgress_Enable

	lis r4, 0x4E80
	ori r4, r4, 0x20
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_RaceSettings_LapProgress_Enable:
	lis r4, 0x7C08
	ori r4, r4, 0x2A6
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:             ModMenu_RaceSettings_SkipCountdown
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_RaceSettings_SkipCountdown:
	STACK_FRAME

	cmpwi r3, 0
	lis r3, "object::RaceCheckerBase::checkToRace"@ha
	lwzu r0, "object::RaceCheckerBase::checkToRace"@l (r3)
	bne ModMenu_RaceSettings_SkipCountdown_Enable

	lis r4, 0x8003
	ori r4, r4, 0x30
	cmpw r4, r0
	beq ModMenu_RaceSettings_SkipCountdown_Exit
	bl InstructionPatcher

	lis r4, 0x2C00
	ori r4, r4, 0xF0
	lis r3, "object::RaceCheckerBase::checkToRace" + 0x4@h
	ori r3, r3, "object::RaceCheckerBase::checkToRace" + 0x4@l
	bl InstructionPatcher

	b ModMenu_RaceSettings_SkipCountdown_Exit

ModMenu_RaceSettings_SkipCountdown_Enable:
	lis r4, 0x3860
	ori r4, r4, 0x1
	cmpw r4, r0
	beq ModMenu_RaceSettings_SkipCountdown_Exit
	bl InstructionPatcher

	lis r4, 0x4E80
	ori r4, r4, 0x20
	lis r3, "object::RaceCheckerBase::checkToRace" + 0x4@h
	ori r3, r3, "object::RaceCheckerBase::checkToRace" + 0x4@l
	bl InstructionPatcher

ModMenu_RaceSettings_SkipCountdown_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:              ModMenu_RaceSettings_StopTimer
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_RaceSettings_StopTimer:
	cmpwi r3, 0
	beqlr

	LOAD_ADDR r12, "addr_RaceDirector"
	cmpwi r12, NULL
	beqlr

	lwz r12, 0x34 (r12)
	cmpwi r12, NULL
	beqlr

	li r0, 0x1
	stb r0, 0x4C (r12)
	blr

/**========================================================================
 ** MARK:            ModMenu_KartSettings_InstantRecover
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_KartSettings_InstantRecover:
	STACK_FRAME 0xC
	stmw r29, 0x8 (r1)

	cmpwi r3, 0
	lis r3, "object::KartVehicleMove::calcReactReduceSpeed"@ha
	lwzu r0, "object::KartVehicleMove::calcReactReduceSpeed"@l (r3)
	bne ModMenu_KartSettings_InstantRecover_Enable

	lis r4, 0x9421
	ori r4, r4, 0xFFB0
	cmpw r4, r0
	bnel- InstructionPatcher

	b ModMenu_KartSettings_InstantRecover_Exit

ModMenu_KartSettings_InstantRecover_Enable:
	lis r4, 0x4E80
	ori r4, r4, 0x20
	cmpw r4, r0
	bnel- InstructionPatcher

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_KartSettings_InstantRecover_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r31, 0x1CC (r12)
	cmpwi r31, 0
	ble ModMenu_KartSettings_InstantRecover_Exit
	li r30, 0

ModMenu_KartSettings_InstantRecover_TryApply:
	mr r3, r30
	bl KartInfoProxy_getKartUnit
	lwz r29, 0x4 (r3)

	lwz r12, 0x14 (r3)
	lwz r3, 0x20C (r12)
	bl KartInfoProxy_isAccident
	cmpwi r3, 0
	beq ModMenu_KartSettings_InstantRecover_TryApplyNext

	mr r3, r29
	bl KartVehicle_forceClearAccident

ModMenu_KartSettings_InstantRecover_TryApplyNext:
	addi r30, r30, 0x1
	subic. r31, r31, 0x1
	bne ModMenu_KartSettings_InstantRecover_TryApply

ModMenu_KartSettings_InstantRecover_Exit:
	lmw r29, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:            ModMenu_KartSettings_InstantRespawn
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_KartSettings_InstantRespawn:
	STACK_FRAME 0xC
	stmw r29, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_KartSettings_InstantRespawn_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_KartSettings_InstantRespawn_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r31, 0x1CC (r12)
	cmpwi r31, 0
	ble ModMenu_KartSettings_InstantRespawn_Exit
	li r30, 0

ModMenu_KartSettings_InstantRespawn_TryApply:
	mr r3, r30
	bl KartInfoProxy_getKartUnit
	lwz r29, 0x4 (r3)

	lwz r12, 0x14 (r3)
	lwz r3, 0x20C (r12)
	bl KartInfoProxy_isJugemHang
	cmpwi r3, 0
	beq ModMenu_KartSettings_InstantRespawn_TryApplyNext

	lwz r3, 0x4C (r29)
	li r4, 0
	bl KartJugemRecover_updateFinalMtx_

	lwz r3, 0x4C (r29)
	bl FUN_finishRecover

ModMenu_KartSettings_InstantRespawn_TryApplyNext:
	addi r30, r30, 0x1
	subic. r31, r31, 0x1
	bne ModMenu_KartSettings_InstantRespawn_TryApply

ModMenu_KartSettings_InstantRespawn_Exit:
	lmw r29, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                ModMenu_KartSettings_MaxAcc
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_KartSettings_MaxAcc:
	cmpwi r3, 0
	lis r3, "object::KartVehicleMove::calcSpeed" + 0x25C@ha
	lwzu r0, "object::KartVehicleMove::calcSpeed" + 0x25C@l (r3)
	lis r4, 0xC18A
	bne ModMenu_KartSettings_MaxAcc_Enable

	ori r4, r4, 0x2D90
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_KartSettings_MaxAcc_Enable:
	ori r4, r4, 0x2DDC
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:               ModMenu_KartSettings_RandomDmg
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_KartSettings_RandomDmg:
	STACK_FRAME 0x10
	stmw r28, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_KartSettings_RandomDmg_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_KartSettings_RandomDmg_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r31, 0x1CC (r12)
	cmpwi r31, 0
	ble ModMenu_KartSettings_RandomDmg_Exit
	li r30, 0

ModMenu_KartSettings_RandomDmg_TryApply:
	li r3, 501
	bl GetRandomNumber
	cmpwi r3, 0
	bne ModMenu_KartSettings_RandomDmg_TryApplyNext

	mr r3, r30
	bl KartInfoProxy_getKartUnit
	lwz r29, 0x4 (r3)
	lwz r28, 0x14 (r3)

	lwz r3, 0x20C (r28)
	bl KartInfoProxy_isJugemHang
	cmpwi r3, 0
	bne ModMenu_KartSettings_RandomDmg_TryApplyNext

	lwz r3, 0x20C (r28)
	bl KartInfoProxy_isKiller
	cmpwi r3, 0
	bne ModMenu_KartSettings_RandomDmg_TryApplyNext

	lwz r3, 0x20C (r28)
	bl KartInfoProxy_isInStar
	cmpwi r3, 0
	bne ModMenu_KartSettings_RandomDmg_TryApplyNext

	li r5, 0x4000
	lwz r6, 0x144 (r29)
	or r5, r5, r6
	rlwinm. r6, r6, 0x12, 0x1F, 0x1F
	bne ModMenu_KartSettings_RandomDmg_TryApplyNext
	stw r5, 0x144 (r29)

	li r3, 0x14
	bl GetRandomNumber
	stw r3, 0x298 (r28)

	lwz r12, 0x20 (r29)

	li r0, 0
	stw r0, 0x1C (r12)
	stw r3, 0xC (r12)

ModMenu_KartSettings_RandomDmg_TryApplyNext:
	addi r30, r30, 0x1
	subic. r31, r31, 0x1
	bne ModMenu_KartSettings_RandomDmg_TryApply

ModMenu_KartSettings_RandomDmg_Exit:
	lmw r28, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                 ModMenu_KartSettings_Star
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_KartSettings_Star:
	STACK_FRAME 0x8
	stw r31, 0xC (r1)
	stw r30, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_KartSettings_Star_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_KartSettings_Star_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r31, 0x1CC (r12)
	cmpwi r31, 0
	ble ModMenu_KartSettings_Star_Exit
	li r30, 0

ModMenu_KartSettings_Star_TryApply:
	mr r3, r30
	bl KartInfoProxy_getKartUnit
	lwz r12, 0x4 (r3)

	lbz r0, 0x66 (r12)
	cmpwi r0, 0
	bne ModMenu_KartSettings_Star_TryApplyNext

	li r0, 0xF
	stw r0, 0x160 (r12)

ModMenu_KartSettings_Star_TryApplyNext:
	addi r30, r30, 0x1
	subic. r31, r31, 0x1
	bne ModMenu_KartSettings_Star_TryApply

ModMenu_KartSettings_Star_Exit:
	lwz r30, 0x8 (r1)
	lwz r31, 0xC (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_ItemSettings_InfiniteItems
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_ItemSettings_InfiniteItems:
	STACK_FRAME 0xC
	stmw r29, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_ItemSettings_InfiniteItems_Exit

	lis r12, "addr_ModMenu_Tools_SuperItemWheel_IsEnabled"@ha
	lbz r0, "addr_ModMenu_Tools_SuperItemWheel_IsEnabled"@l (r12)
	cmpwi r0, 0
	bne ModMenu_ItemSettings_InfiniteItems_Exit

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_ItemSettings_InfiniteItems_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r31, 0x1CC (r12)
	cmpwi r31, 0
	ble ModMenu_ItemSettings_InfiniteItems_Exit
	li r30, 0

ModMenu_ItemSettings_InfiniteItems_TryApply:
	mr r3, r30
	bl KartInfoProxy_getKartUnit
	lwz r29, 0x4 (r3)

	lbz r0, 0x66 (r29)
	cmpwi r0, 0
	bne ModMenu_ItemSettings_InfiniteItems_TryApplyNext

	bl ModMenu_KartUnit_isAvailableCatch
	cmpwi r3, 0
	beq ModMenu_ItemSettings_InfiniteItems_TryApplyNext

	lwz r4, 0x20 (r29)
	bl FUN_setItemBoxForce

ModMenu_ItemSettings_InfiniteItems_TryApplyNext:
	addi r30, r30, 0x1
	subic. r31, r31, 0x1
	bne ModMenu_ItemSettings_InfiniteItems_TryApply

ModMenu_ItemSettings_InfiniteItems_Exit:
	lmw r29, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:            ModMenu_ItemSettings_InstantItemBox
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_ItemSettings_InstantItemBox:
	lis r12, "addr_ItemSlot_LastSpin"@ha
	cmpwi r3, 0
	bne ModMenu_ItemSettings_InstantItemBox_Enable

	li r0, 0xB4
	stw r0, "addr_ItemSlot_LastSpin"@l (r12)
	blr

ModMenu_ItemSettings_InstantItemBox_Enable:
	li r0, 0
	stw r0, "addr_ItemSlot_LastSpin"@l (r12)
	blr

/**========================================================================
 ** MARK:            ModMenu_ItemSettings_ModifyLimiters
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_ItemSettings_ModifyLimiters:
	cmpwi r3, 0
	lis r3, "object::GetNum_InItemType" + 0x28C@ha
	lwzu r0, "object::GetNum_InItemType" + 0x28C@l (r3)
	bne ModMenu_ItemSettings_ModifyLimiters_Enable

	lis r4, 0x7D63
	ori r4, r4, 0x5B78
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_ItemSettings_ModifyLimiters_Enable:
	lis r4, 0x3860
	ori r4, r4, 0xC
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:               ModMenu_ItemSettings_RapidFire
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_ItemSettings_RapidFire:
	STACK_FRAME

	cmpwi r3, 0
	lis r3, "object::ItemDirector::calcKeyInput_EachPlayer_" + 0x5A8@ha
	lwzu r0, "object::ItemDirector::calcKeyInput_EachPlayer_" + 0x5A8@l (r3)
	bne ModMenu_ItemSettings_RapidFire_Enable

	lis r4, 0x880C
	cmpw r4, r0
	bnel- InstructionPatcher

	b ModMenu_ItemSettings_RapidFire_Exit

ModMenu_ItemSettings_RapidFire_Enable:
	lis r4, 0x3800
	cmpw r4, r0
	bnel- InstructionPatcher

	bl ModMenu_isRaceReady
	cmpwi r3, false
	beq ModMenu_ItemSettings_RapidFire_Exit

	LOAD_ADDR r12, "addr_RaceDirector"
	lwz r5, 0x1CC (r12)
	cmpwi r5, 0
	ble ModMenu_ItemSettings_RapidFire_Exit
	li r6, 0

	LOAD_ADDR r12, "addr_ItemDirector"

ModMenu_ItemSettings_RapidFire_TryApply:
	lwz r11, 0x7B8 (r12)

	li r0, 0
	stbx r0, r11, r6

	addi r6, r6, 0x1
	subic. r5, r5, 0x1
	bne ModMenu_ItemSettings_RapidFire_TryApply

ModMenu_ItemSettings_RapidFire_Exit:
	RETURN_SEQ

/**========================================================================
 ** MARK:           ModMenu_ItemSettings_UnbreakableItems
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_ItemSettings_UnbreakableItems:
	cmpwi r3, 0
	lis r3, "object::ItemObjBase::react_Break"@ha
	lwzu r0, "object::ItemObjBase::react_Break"@l (r3)
	bne ModMenu_ItemSettings_UnbreakableItems_Enable

	lis r4, 0x8183
	cmpw r4, r0
	bne- InstructionPatcher
	blr

ModMenu_ItemSettings_UnbreakableItems_Enable:
	lis r4, 0x4E80
	ori r4, r4, 0x20
	cmpw r4, r0
	bne- InstructionPatcher
	blr

/**========================================================================
 ** MARK:                 ModMenu_SaveData_BestStats
 *@param1 r3, "isEnabled", bool
 *@param2 r4, "page id", unsigned int
 *@param3 r5, "page item id", unsigned int
 *========================================================================**/
ModMenu_SaveData_BestStats:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_SaveData_BestStats_Exit

	LOAD_ADDR r3, "addr_ModMenu_DialogPage_PageArray"
	bl ModMenu_DialogPageSelector_GetItem
	lbz r0, 0xF (r3)
	clrrwi r0, r0, 1
	stb r0, 0xF (r3)

	bl ModMenu_DialogBox_RequestClose

	bl SystemEngine_getEngine
	lwz r31, 0x2C8 (r3)
	lwz r12, 0xE4 (r31)
	lbz r4, 0x15C (r12)
	mr r3, r31
	bl SaveDataManager_getUserSaveDataPtr
	lwz r12, 0x158 (r3)

	lis r5, 9999999@h
	ori r5, r5, 9999999@l
	li r6, 0
	lis r7, 99999@h
	ori r7, r7, 99999@l
	stw r5, 0x14E8 (r12)
	stw r5, 0x14F0 (r12)
	stw r5, 0x14F4 (r12)
	stw r5, 0x14FC (r12)
	stw r5, 0x1500 (r12)
	stw r5, 0x1504 (r12)
	stw r5, 0x1A18 (r12)
	stw r6, 0x1508 (r12)
	stw r6, 0x1A1C (r12)
	stw r7, 0x1A20 (r12)
	stw r7, 0x1A24 (r12)

	mr r3, r31
	bl SaveDataManager_saveUserData

ModMenu_SaveData_BestStats_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_SaveData_ResetBattleRating
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SaveData_ResetBattleRating:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_SaveData_ResetBattleRating_Exit

	LOAD_ADDR r3, "addr_ModMenu_DialogPage_PageArray"
	bl ModMenu_DialogPageSelector_GetItem
	lbz r0, 0xF (r3)
	clrrwi r0, r0, 1
	stb r0, 0xF (r3)

	bl ModMenu_DialogBox_RequestClose

	bl SystemEngine_getEngine
	lwz r31, 0x2C8 (r3)
	lwz r12, 0xE4 (r31)
	lbz r4, 0x15C (r12)
	mr r3, r31
	bl SaveDataManager_getUserSaveDataPtr
	lwz r12, 0x158 (r3)

	li r0, 1000
	stw r0, 0x1A24 (r12)

	mr r3, r31
	bl SaveDataManager_saveUserData

ModMenu_SaveData_ResetBattleRating_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_SaveData_ResetVersusRating
 *@param1 r3, "isEnabled", bool
 *========================================================================**/
ModMenu_SaveData_ResetVersusRating:
	STACK_FRAME 0x4
	stw r31, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_SaveData_ResetVersusRating_Exit

	LOAD_ADDR r3, "addr_ModMenu_DialogPage_PageArray"
	bl ModMenu_DialogPageSelector_GetItem
	lbz r0, 0xF (r3)
	clrrwi r0, r0, 1
	stb r0, 0xF (r3)

	bl ModMenu_DialogBox_RequestClose

	bl SystemEngine_getEngine
	lwz r31, 0x2C8 (r3)
	lwz r12, 0xE4 (r31)
	lbz r4, 0x15C (r12)
	mr r3, r31
	bl SaveDataManager_getUserSaveDataPtr
	lwz r12, 0x158 (r3)

	li r0, 1000
	stw r0, 0x1A20 (r12)

	mr r3, r31
	bl SaveDataManager_saveUserData

ModMenu_SaveData_ResetVersusRating_Exit:
	lwz r31, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:             ModMenu_SaveData_UnlockEverything
 *@param1 r3, "isEnabled", bool
 *@param2 r4, "page id", unsigned int
 *@param3 r5, "page item id", unsigned int
 *========================================================================**/
ModMenu_SaveData_UnlockEverything:
	STACK_FRAME 0xC
	stmw r29, 0x8 (r1)

	cmpwi r3, 0
	beq ModMenu_SaveData_UnlockEverything_exit

	LOAD_ADDR r3, "addr_ModMenu_DialogPage_PageArray"
	bl ModMenu_DialogPageSelector_GetItem
	lbz r0, 0xF (r3)
	clrrwi r0, r0, 1
	stb r0, 0xF (r3)

	bl ModMenu_DialogBox_RequestClose

	bl SystemEngine_getEngine
	lwz r31, 0x2C8 (r3)
	lwz r12, 0xE4 (r31)
	lbz r4, 0x15C (r12)
	mr r3, r31
	bl SaveDataManager_getUserSaveDataPtr
	lwz r30, 0x158 (r3)

	addi r3, r30, 0x4CC
	li r29, 5

ModMenu_SaveData_UnlockEverything_FillChunks:
	li r4, 0x3
	li r5, 0xC
	bl OSBlockSet
	addi r3, r3, 0x20
	subic. r29, r29, 0x1
	bne ModMenu_SaveData_UnlockEverything_FillChunks

	addi r3, r30, 0x5CC
	li r29, 5

ModMenu_SaveData_UnlockEverything_FillChunks2:
	li r4, 0x3
	li r5, 0xC
	bl OSBlockSet
	addi r3, r3, 0x20
	subic. r29, r29, 0x1
	bne ModMenu_SaveData_UnlockEverything_FillChunks2

	addi r3, r30, 0x1A28
	li r4, 0x3
	li r5, 0x8
	bl OSBlockSet

	addi r3, r30, 0x1A50
	li r4, 0x3
	li r5, 0x1E
	bl OSBlockSet

	addi r3, r30, 0x1A90
	li r4, 0x3
	li r5, 0x1A
	bl OSBlockSet

	addi r3, r30, 0x1AD0
	li r4, 0x3
	li r5, 0x12
	bl OSBlockSet

	addi r3, r30, 0x1B10
	li r4, 0x3
	li r5, 0xC
	bl OSBlockSet

	addi r3, r30, 0x1B5A
	li r4, 0x3
	li r5, 0x5A
	bl OSBlockSet

	mr r3, r31
	bl SaveDataManager_saveUserData

ModMenu_SaveData_UnlockEverything_exit:
	lmw r29, 0x8 (r1)
	RETURN_SEQ

/**========================================================================
 ** MARK:                    ModMenu_isRaceReady
 *@return r3, "isRaceReady", bool
 *========================================================================**/
ModMenu_isRaceReady:
	LOAD_ADDR r3, "addr_RaceDirector"
	cmpwi r3, NULL
	beqlr

	lwz r3, 0x23C (r3)
	cmpwi r3, NULL
	beqlr

	lbz r3, 0x3E (r3)
	cmpwi r3, false
	beqlr

	b IsRaceState

/**========================================================================
 ** MARK:             ModMenu_KartUnit_isAvailableCatch
 *@param1 r3, "KartUnit", address
 *@return r3, "isAvailableCatch", bool
 *========================================================================**/
ModMenu_KartUnit_isAvailableCatch:
	STACK_FRAME 0x8
	stw r31, 0xC (r1)
	stw r30, 0x8 (r1)

	lwz r12, 0xC (r3)
	lwz r31, 0x5C (r12)

	lwz r12, 0x14 (r3)
	lwz r30, 0x20C (r12)

	lwz r12, 0x3C (r31)
	lbz r0, 0x29 (r12)
	cmpwi r0, 0
	bne ModMenu_KartUnit_isAvailableCatch_failure

	mr r3, r31
	bl ItemOwnerProxy_isKeep
	cmpwi r3, 0
	bne ModMenu_KartUnit_isAvailableCatch_failure

	mr r3, r31
	bl ItemOwnerProxy_isThrowing
	cmpwi r3, 0
	bne ModMenu_KartUnit_isAvailableCatch_failure

	mr r3, r30
	bl KartInfoProxy_isGoal
	cmpwi r3, 0
	bne ModMenu_KartUnit_isAvailableCatch_failure

	lwz r31, 0x70 (r31)
	cmpwi r31, NULL
	beq ModMenu_KartUnit_isAvailableCatch_success

	lbz r0, 0x1B6 (r31)
	cmpwi r0, 0
	bne ModMenu_KartUnit_isAvailableCatch_success

	lbz r0, 0x2D (r31)
	cmpwi r0, 0x4
	bne ModMenu_KartUnit_isAvailableCatch_success

	bl FUN_GetMinItemTime
	lwz r0, 0x30 (r31)
	cmpw r0, r3
	bge ModMenu_KartUnit_isAvailableCatch_success

ModMenu_KartUnit_isAvailableCatch_failure:
	li r3, false
	b ModMenu_KartUnit_isAvailableCatch_Exit

ModMenu_KartUnit_isAvailableCatch_success:
	li r3, true

ModMenu_KartUnit_isAvailableCatch_Exit:
	lwz r30, 0x8 (r1)
	lwz r31, 0xC (r1)
	RETURN_SEQ

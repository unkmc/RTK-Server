Config = {
    -- ---------------------------------------------------------------------------
    -- When enabled, many items dropped by bosses (e.g. Lucky coin, Fragile rose)
    -- can be sold to certain NPCs.
    -- ---------------------------------------------------------------------------
    bossDropSalesEnabled = false,

    -- ----------------------------------------------------------------------------
    -- When enabled, the 1/25 chance of a crafting skill bonus always applies even
    -- when it is not one's totem time. Default value is false.
    -- ----------------------------------------------------------------------------
    craftingBonusAlwaysEnabled = true,

    -- -------------------------------------------------------------------------------
    -- Determines how fast/slow the cost of selling experience scales with vita/mana.
    -- You probably should not mess with these unless you have a good understanding
    -- of the math used in the exp selling formula. Default value is 1 in both cases.
    -- -------------------------------------------------------------------------------
    expSellFactor1 = 0,
    expSellFactor2 = 2,

    -- ---------------------------------------------------------------------------
    -- Removes karma, item, and blessed by the watcher requirements when enabled.
    -- This is used only to facilitate beta testing.
    -- Default value is false.
    -- ---------------------------------------------------------------------------
    freeNpcSubpathsEnabled = true,

	-- -------------------------------------------------------------------------
	-- Allows non-GM players to alter their stats and to spawn items on demand.
    -- This is used only to facilitate beta testing.
    -- Default value is false.
	-- -------------------------------------------------------------------------
	freeStatsAndItemsEnabled = true,

    -- -----------------------------------------------------------------------------    
    -- When enabled, a Love or Blood stone can be used to teleport to one's partner
    -- even if the two are in different regions. Default value is false.
    -- -----------------------------------------------------------------------------
    interRegionLoveEnabled = true,

    -- ----------------------------------------------------------------------------
    -- Determines how fast spells can be learned. The required level is multiplied
    -- by this factor. (e.g. Set to 0.5 to learn level 80 spells at level 40.)
    -- Default value is 1.
    -- ----------------------------------------------------------------------------
    learnSpellsFactor = 1,

    -- ---------------------------------------------------------------------------------
    -- Sets the maximum possible required level for spells. (e.g. Set to 20 to make all
    -- 20+ spells available at level 20.) This will override Config.learnSpellsFactor.
    -- Default value is 100.
    -- ---------------------------------------------------------------------------------
    learnSpellsMaxLevel = 100,

    -- ---------------------------------------------------------------------------------
    -- Toggles the Lua functions for logging. These are very inefficient and need to be
    -- rewritten. Disabling them isn't ideal but can help with performance in a pinch.
    -- Default value is true.
    -- ---------------------------------------------------------------------------------
    loggingEnabled = false,

    -- ------------------------------------------------------------------------------
    -- The number of milliseconds after using a Love or Blood stone before it can be
    -- used again. Default value is 1500.
    -- ------------------------------------------------------------------------------
    loveRingDelay = 0,

    -- ------------------------------------------------------------------------
    -- When enabled, players may choose to enter lower levels of Mythic caves.
    -- GMs always have this option. Default value is false.
    -- ------------------------------------------------------------------------
    mythicCaveSelectEnabled = false, -- ###### This feature is bugged for non-GMs; only first room works ######

    -- -------------------------------------------------------------------
    -- Used to quickly adjust spawn rates used by the MobSpawnHandlerNpc.
    -- Fast spawns will override rebalanced spawns when both are used.
    -- Default values are true and false, respectively.
    -- -------------------------------------------------------------------
    rebalancedSpawnsEnabled = true,
    fastSpawnsEnabled = false,

	-- ------------------------------------------------------
	-- Allows marriage without the three day waiting period.
	-- Default value is false.
	-- ------------------------------------------------------
	shotgunWeddingEnabled = true,

    -- -----------------------------------------------------------------------
    -- When enabled, players receive a basic horse mount along with the usual
    -- peasant gear during the first tutorial. Default value is false.
    -- -----------------------------------------------------------------------
    tutorialMountEnabled = true
}

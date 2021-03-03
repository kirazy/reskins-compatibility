-- Copyright (c) 2021 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE in the project directory for license information.

-- Only reskin chemical plants when Mini-machines pulls from the vanilla chemical plants
-- until such time as we handle the angels chemical plants as well
if reskins.lib.setting("angels-disable-bobs-chemical-plants") == true then
    reskins.compatibility.triggers.minimachines.chemplants = false
end
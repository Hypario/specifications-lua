-------------------------------------------------------------
-- reactor_specs.lua
-- User-level specification constructors
-- This is an example of how you might use the Specification class to create user-friendly functions for building specifications.
-------------------------------------------------------------

local specs = require("specification") -- import the library
local RuleRegistry = specs.RuleRegistry -- get the rule registry
local Specification = specs.Specification -- get the specification class

local tags = {
    temperature_below = "temperature_below",
    fuel_above = "fuel_above",
    coolant_above = "coolant_above",
    damage_below = "damage_below"
}

--------------------------------------------------------------
--- Define the rules in the registry. 
--- In a real application, these would be defined in a separate module and could be more complex.
--------------------------------------------------------------

RuleRegistry.define(tags.temperature_below, function(reactor, threshold)
    return reactor.temperature < threshold
end)

RuleRegistry.define(tags.fuel_above, function(r, threshold)
    return r.fuel >= threshold
end)

RuleRegistry.define(tags.coolant_above, function(r, threshold)
    return r.coolant >= threshold
end)

RuleRegistry.define(tags.damage_below, function(r, threshold)
    return r.damage <= threshold
end)

--------------------------------------------------------------
--- User-friendly specification constructors. 
--- In a real application, you might want to add error handling, validation, or support for more complex specifications.
------------------------------------------------------------------

local function max_temperature_below(limit)
    return Specification:new(tags.temperature_below, limit)
end

local function has_enough_fuel(min)
    return Specification:new(tags.fuel_above, min)
end

local function has_enough_coolant(min)
    return Specification:new(tags.coolant_above, min)
end

local function damage_below(max)
    return Specification:new(tags.damage_below, max)
end

-------------------------------------------------------------
-- Return the module with the user-friendly spec constructors
-------------------------------------------------------------

return {
    max_temperature_below = max_temperature_below,
    has_enough_fuel = has_enough_fuel,
    has_enough_coolant = has_enough_coolant,
    damage_below = damage_below
}

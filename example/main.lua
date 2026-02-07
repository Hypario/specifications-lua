#!/usr/bin/env lua

local specs = require("reactor_specs")

local reactor = {
    temperature = 85,
    fuel = 1200,
    coolant = 900,
    damage = 0.12
}

-- User-friendly spec building
local safe =
    specs.max_temperature_below(100)
        :And(specs.has_enough_fuel(1000))
        :And(specs.has_enough_coolant(800))
        :And(specs.damage_below(0.20))

--  interpretation
print("Result:", safe:is_satisfied_by(reactor))

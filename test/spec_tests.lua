-- Simple unit tests for specification DSL

-- Ensure Lua can find modules in ./src
package.path = './src/?.lua;' .. package.path

local Specification = require('specification')
local RuleRegistry = require('rule_registry')

local function assert(cond, msg)
    if not cond then error(msg or 'assertion failed') end
end

-- Define rules
RuleRegistry.define('temperature_in_range', function(r, min, max)
    return r.temperature >= min and r.temperature <= max
end)

RuleRegistry.define('fuel_above', function(r, threshold)
    return r.fuel >= threshold
end)

RuleRegistry.define('damage_below', function(r, threshold)
    return r.damage <= threshold
end)

-- Candidate object
local reactor = { temperature = 75, fuel = 50, coolant = 20, damage = 5 }

-- Tests
local s1 = Specification.from('temperature_in_range', 50, 80)
assert(s1:is_satisfied_by(reactor), 'temperature_in_range failed')

local s2 = Specification.from('fuel_above', 60)
assert(not s2:is_satisfied_by(reactor), 'fuel_above should fail')

local combined = s1:And(Specification.from('fuel_above', 40))
assert(combined:is_satisfied_by(reactor), 'combined spec failed')

local dspec = Specification.from('damage_below', 10)
assert(dspec:is_satisfied_by(reactor), 'damage_below failed')

local not_d = dspec:Not()
assert(not not_d:is_satisfied_by(reactor), 'negation failed')

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
describe('temperature_in_range', function()
    it('should be satisfied when temperature is within range', function()
        local spec = Specification.from('temperature_in_range', 50, 80)
        assert(spec:is_satisfied_by(reactor), 'temperature_in_range failed')
    end)

    it('should not be satisfied when temperature is out of range', function()
        local spec = Specification.from('temperature_in_range', 60, 70)
        assert(not spec:is_satisfied_by(reactor), 'temperature_in_range should fail')
    end)
end)

describe('fuel_above', function()
    it('should be satisfied when fuel is above threshold', function()
        local spec = Specification.from('fuel_above', 40)
        assert(spec:is_satisfied_by(reactor), 'fuel_above failed')
    end)

    it('should not be satisfied when fuel is below threshold', function()
        local spec = Specification.from('fuel_above', 60)
        assert(not spec:is_satisfied_by(reactor), 'fuel_above should fail')
    end)
end)

describe('damage_below', function()
    it('should be satisfied when damage is below threshold', function()
        local spec = Specification.from('damage_below', 10)
        assert(spec:is_satisfied_by(reactor), 'damage_below failed')
    end)

    it('should not be satisfied when damage is above threshold', function()
        local spec = Specification.from('damage_below', 3)
        assert(not spec:is_satisfied_by(reactor), 'damage_below should fail')
    end)
end)

describe('combined specifications', function()
    it('should be satisfied when all specs are satisfied', function()
        local s1 = Specification.from('temperature_in_range', 50, 80)
        local s2 = Specification.from('fuel_above', 40)
        local combined = s1:And(s2)
        assert(combined:is_satisfied_by(reactor), 'combined spec failed')
    end)

    it('should not be satisfied when one spec fails', function()
        local s1 = Specification.from('temperature_in_range', 50, 80)
        local s2 = Specification.from('fuel_above', 60)
        local combined = s1:And(s2)
        assert(not combined:is_satisfied_by(reactor), 'combined spec should fail')
    end)
end)

describe('negation', function()
    it('should not be satisfied when damage is below threshold', function()
        -- This spec is satisfied when damage is NOT below 10, i.e., when damage is 10 or above.
        local spec = Specification:new('damage_below', 10):Not()  
        assert(not spec:is_satisfied_by(reactor), 'damage_below failed') -- This should fail because damage is 5, which is below 10.
    end)

    it('should be satisfied when damage is above threshold', function()
        -- This spec is satisfied when damage is NOT below 3, i.e., when damage is 3 or above.
        local spec = Specification:new('damage_below', 3):Not()  
        assert(spec:is_satisfied_by(reactor), 'damage_below should fail') -- This should pass because damage is 5, which is above 3.
    end)
end)
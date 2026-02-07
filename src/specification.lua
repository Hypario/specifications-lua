-------------------------------------------------------------
-- Specification.lua
-- User-friendly functional specs + internal compilation
-------------------------------------------------------------

local Specification = {}
Specification.__index = Specification

-------------------------------------------------------------
-- Constructor for simple predicate-based specification
-------------------------------------------------------------
-- Create a base specification.
-- `tag` may be:
--  - a string key looked up in the RuleRegistry
--  - a function directly called with `(candidate, unpack(params))`
-- `value_or_params` may be a single value or a table of parameters.
function Specification:new(tag, value_or_params)
    local params
    if type(value_or_params) == "table" then
        params = value_or_params
    elseif value_or_params == nil then
        params = {}
    else
        params = { value_or_params }
    end

    return setmetatable({
        kind = "base",
        tag = tag,
        params = params,
    }, self)
end

-- Convenience constructor for vararg parameters: Specification.from(tag, ...)
function Specification.from(tag, ...)
    local args = { ... }
    return Specification:new(tag, args)
end

-- Note: intentionally avoid providing a `from_fn` helper to keep rule
-- definitions and specification construction separated.

-------------------------------------------------------------
-- Composite specification (AND)
-------------------------------------------------------------
function Specification:And(other)
    return setmetatable({kind = "and", left = self, right = other}, Specification)
end

-------------------------------------------------------------
-- Composite specification (OR)
-------------------------------------------------------------
function Specification:Or(other)
    return setmetatable({kind = "or", left = self, right = other}, Specification)
end

-------------------------------------------------------------
-- Composite specification (NOT)
-------------------------------------------------------------
function Specification:Not()
    return setmetatable({kind = "not", inner = self}, Specification)
end

-------------------------------------------------------------
-- Evaluation of the specification against a candidate object
-- This is where the internal compilation happens: we interpret the specification tree and evaluate it using the registered rules.
-------------------------------------------------------------

local RuleRegistry = require("rule_registry")

function Specification:is_satisfied_by(candidate)
    if self.kind == "base" then
        -- If tag is a function, call it directly with the candidate and params.
        if type(self.tag) == "function" then
            return self.tag(candidate, table.unpack(self.params))
        end

        local rule = RuleRegistry.get(self.tag)
        if not rule then
            error("No rule registered for tag: " .. tostring(self.tag))
        end
        return rule(candidate, table.unpack(self.params))

    elseif self.kind == "and" then
        return self.left:is_satisfied_by(candidate)
            and self.right:is_satisfied_by(candidate)

    elseif self.kind == "or" then
        return self.left:is_satisfied_by(candidate)
            or self.right:is_satisfied_by(candidate)

    elseif self.kind == "not" then
        return not self.inner:is_satisfied_by(candidate)
    end
end

return Specification
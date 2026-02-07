
---------------------------------------------------------
----------------Auto generated code block----------------
---------------------------------------------------------

do
    local searchers = package.searchers or package.loaders
    local origin_seacher = searchers[2]
    searchers[2] = function(path)
        local files =
        {
------------------------
-- Modules part begin --
------------------------

["rule_registry"] = function()
--------------------
-- Module: 'rule_registry'
--------------------
-------------------------------------------------------------
-- rule_registry.lua
-- Central registry for all rules and their evaluators
-------------------------------------------------------------

local RuleRegistry = {}

function RuleRegistry.define(tag, predicate)
    RuleRegistry[tag] = predicate
end

function RuleRegistry.get(tag)
    return RuleRegistry[tag]
end

return RuleRegistry
end,

["specification"] = function()
--------------------
-- Module: 'specification'
--------------------
-------------------------------------------------------------
-- Specification.lua
-- User-friendly functional specs + internal compilation
-------------------------------------------------------------

local Specification = {}
Specification.__index = Specification

-------------------------------------------------------------
-- Constructor for simple predicate-based specification
-------------------------------------------------------------
function Specification:new(tag, value)
    return setmetatable({
        kind = "base",
        tag = tag,        -- e.g. "temperature_below"
        value = value,    -- e.g. 100
    }, self)
end

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
        local rule = RuleRegistry.get(self.tag)
        return rule(candidate, self.value)

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
end,

----------------------
-- Modules part end --
----------------------
        }
        if files[path] then
            return files[path]
        else
            return origin_seacher(path)
        end
    end
end
---------------------------------------------------------
----------------Auto generated code block----------------
---------------------------------------------------------
local Specification = require("specification")
local RuleRegistry = require("rule_registry")

return {
    Specification = Specification,
    RuleRegistry = RuleRegistry
}
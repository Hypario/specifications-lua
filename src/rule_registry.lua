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
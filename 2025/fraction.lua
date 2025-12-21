local function get_gcd(a, b)
	local x = a
	local y = b
	while (y ~= 0) do
		local temp = y
		y = x % y
		x = temp
	end

	return x
end

Fraction = {}

function Fraction.new(a, b)
	return { num = a, den = b } --numenator / denominator
end

function Fraction.fromInt(a)
	return { num = a, den = 1 }
end

function Fraction.empty()
	return { num = 0, den = 0 }
end

function Fraction.mulByInt(r, value)
	--[[
	return { num = r.num * value, den = r.den }
	--return Fraction.mul(r, Fraction.fromInt(value))
	--]]

	local ratio =  { num = r.num * value, den = r.den }
	return Fraction.simplify(ratio)
end

function Fraction.mul(a, b)
	--[[
	return { num = a.num * b.num, den = a.den * b.den }
	--]]
	local ratio = { num = a.num * b.num, den = a.den * b.den }
	return Fraction.simplify(ratio)
end

function Fraction.divByInt(r, value)
	--[[
	return { num = r.num, den = r.den * value }
	--return Fraction.div(r, Fraction.fromInt(value))
	--]]
	local ratio =  { num = r.num, den = r.den * value }
	return Fraction.simplify(ratio)
end

function Fraction.div(a, b)
	--[[
	return { num = a.num * b.den, den = a.den * b.num }
	--return Fraction.mul(a, Fraction.invert(b))
	--]]
	local ratio = { num = a.num * b.den, den = a.den * b.num }
	return Fraction.simplify(ratio)
end

function Fraction.addByInt(r, value)
	--[[
	return { num = r.num + (value*r.den), den = r.den }
	--return Fraction.add(r, Fraction.fromInt(value))
	--]]
	local ratio = { num = r.num + (value*r.den), den = r.den }
	return Fraction.simplify(ratio)
end

function Fraction.add(a, b)
	--[[
	return { num = (a.num*b.den)+(b.num*a.den), den = (a.den*b.den) }
	--]]
	local ratio = { num = (a.num*b.den)+(b.num*a.den), den = (a.den*b.den) }
	return Fraction.simplify(ratio)
end

function Fraction.subByInt(r, value)
	--[[
	return { num = r.num - (value*r.den), den = r.den }
	--return Fraction.sub(r, Fraction.fromInt(value))
	--]]
	local ratio = { num = r.num - (value*r.den), den = r.den }
	return Fraction.simplify(ratio)
end

function Fraction.sub(a, b)
	--[[
	return { num = (a.num*b.den)-(b.num*a.den), den = (a.den*b.den) }
	--]]
	local ratio = { num = (a.num*b.den)-(b.num*a.den), den = (a.den*b.den) }
	return Fraction.simplify(ratio)
end

function Fraction.invert(r)
	--[[
	return { num = r.den, den = r.num }
	--]]
	local ratio = { num = r.den, den = r.num }
	return Fraction.simplify(ratio)
end

function Fraction.isWhole(r)
	local simplified = Fraction.simplify(r)
	return (math.abs(simplified.den)==1) or (math.abs(r.num)==0) or (math.abs(r.den)==0) or (math.abs(r.num)==math.abs(r.den))
end

function Fraction.isZero(r)
	local simplified = Fraction.simplify(r)
	return (math.abs(simplified.num)==0) or (math.abs(r.den)==0)
end

function Fraction.simplify(r)
	local gcd = get_gcd(r.num, r.den)

	--return { num = r.num / gcd, den = r.den / gcd }
	--return { num = r.num // gcd, den = r.den // gcd }
	return { num = math.floor(r.num / gcd), den = math.floor(r.den / gcd) }
end

function Fraction.value(r)
	return r.num / r.den
end

return Fraction

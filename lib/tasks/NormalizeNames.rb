module Normalizer

	names = {
		'A.P.C.' => ['Atelier de Production et de Création', 'Atelier de Production et de Creation'],
		'example' => ['eXXXample', 'essample']
	}


	#
	# This strips whitespace, right? Double check...
	#
	def Normalizer.essence(name)
		name.strip.downcase.gsub(/[^a-z0-9]/, '').gsub('&', 'and').gsub('$', 's').gsub('+', 'plus')
	end


	def Normalizer.normalize(name)

		names.each do |k, v|

			return k if Normalizer.essence(k) == Normalizer.essence(name)

			v.each do |n|
				return k if Normalizer.essence(n) == Normalizer.essence(name)
			end
		end

		return name
	end

end
#enconding: utf-8

require 'tipo_sorpresa'

module ModeloQytetet
  
  class Sorpresa
  
   attr_reader :texto,:valor,:tipo
  
   def initialize(t,v,ts)
     @texto = t
     @valor = v
     @tipo = ts
    end
  
    def to_s
       "Texto: #{@texto} \n Valor: #{@valor} \n Tipo: #{@tipo}"
    end
  end
end

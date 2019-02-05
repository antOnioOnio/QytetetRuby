#encoding: utf-8

require "singleton"

module ModeloQytetet
  
  
  class Dado
    
    include Singleton
  
    def tirar
      numero = 0
      numero = rand(6)+1
      numero
    end
    
  end
  
end

#encoding: utf-8
###

require 'titulo_propiedad'
require 'tipo_casilla'


module ModeloQytetet 
  
  class Casilla
    
    attr_reader :numeroCasilla, :coste,  :tipo 
   
#--------------------------------------------------------------    
    def initialize(numeroC, cost, tip)
      @numeroCasilla =numeroC
      @coste = cost
      @tipo = tip 

    end

#-------------------------------------------------------------- 
#    def self.crear_casilla_normal(numero,cost,tip)
#      new(numero,cost,tip)
#    end

#--------------------------------------------------------------    
    def soyEdificable
      false
    end
 #--------------------------------------------------------------    
 
    def to_s
        resultado = "Numero de casilla : #{@numeroCasilla} \n Coste: #{@coste} \n Tipo: #{@tipo} \n"
     
        resultado
    end
#--------------------------------------------------------------      
      
  end

end
  

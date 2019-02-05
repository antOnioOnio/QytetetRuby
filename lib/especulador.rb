#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require 'jugador'
module ModeloQytetet
  
  class Especulador < Jugador
    
    @@FactorEspeculador = 2
    attr_reader  :fianza
    
    def initialize(jugador, fianza)
      
      copiaJugador(jugador)
      @fianza = fianza
 
    end
    
    def convertirme(cant)
      self 
    end
    
    def pagarImpuesto(cant)
      apagar = cant/@@FactorEspeculador
      modificarSaldo(-apagar)
    end
    
    def irAcarcel(carcel)
      voy = pagarFianza(@fianza)
      if !voy
        @encarcelado = true
        @casillaActual= carcel
      end
    end
    
    def pagarFianza(cant)
      tengo = false
      if tengoSaldo(cantidad)
        tengo = true
        modificarSaldo(-cantidad)
      end
      tengo
    end
    
    def to_s
      casilla = super
      casilla += "Fianza = #{@fianza}"
      casilla
    end
     
  end
end

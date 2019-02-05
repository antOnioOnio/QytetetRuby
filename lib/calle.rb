#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'casilla'
require 'especulador'
require 'titulo_propiedad'

module ModeloQytetet
  class Calle < Casilla
    
   attr_accessor :tituloPropiedad, :numCasas, :numHoteles 
  
   def initialize(num_casilla, coste, titulo)
      super(num_casilla,coste, TipoCasilla::CALLE)
      @numHoteles = 0
      @numCasas = 0
      @tituloPropiedad = titulo
      asignarTituloPropiedad
    end
    
    
  #--------------------------------------------------------------     
    def asignarPropietario(jugador)
      if (jugador != nil)
      @tituloPropiedad.propietario = jugador
      end
      @tituloPropiedad
    end
  #--------------------------------------------------------------    
    def calcularValorHipoteca
        valor = 0;
        hBase = @tituloPropiedad.hipotecaBase
        
        valor = hBase + @numCasas*0.5*hBase+@numHoteles*hBase 
         
        Integer(valor);
    end  
    
  #--------------------------------------------------------------    
    def cancelarHipoteca
      @tituloPropiedad.hipotecada = false
    end 
    
  #--------------------------------------------------------------    
    def cobrarAlquiler
      
      costeAlquilerBase = @tituloPropiedad.alquilerBase
      
      costeAlquiler = costeAlquilerBase + @numCasas*0.5 + @numHoteles*2
      
      @tituloPropiedad.propietario.modificarSaldo(costeAlquiler)
      
      costeAlquiler
    end
    
  #--------------------------------------------------------------    
    def edificarCasa
      @numCasas = @numCasas+1
      costeEdificarCasa = @tituloPropiedad.precioEdificar
      costeEdificarCasa
    end
#--------------------------------------------------------------    
    def edificarHotel
      @numHoteles = @numHoteles+1
      @numCasas = 0
      costeEdificarHotel = @tituloPropiedad.precioEdificar
      costeEdificarHotel
    end
#--------------------------------------------------------------    
    def estaHipotecada
      esta = false
      if  @tituloPropiedad != nil
        esta = @tituloPropiedad.hipotecada
      end
      esta
    end
#--------------------------------------------------------------    
    def getCosteHipoteca
      return calcularValorHipoteca
    end  
    
#--------------------------------------------------------------    
    def precioEdificar
      @tituloPropiedad.precioEdificar
    end
#--------------------------------------------------------------    
    def hipotecar
      @tituloPropiedad.hipotecada = true
      cantidadRecibida = self.calcularValorHipoteca
      cantidadRecibida
    end
#--------------------------------------------------------------    
    def precioTotalComprar
      precio = @coste + (@numCasas+@numHoteles)*@tituloPropiedad.precioEdificar
      precio
    end   
 #--------------------------------------------------------------    
    def propietarioEncarcelado
      @tituloPropiedad.propietario.encarcelado
    end
#--------------------------------------------------------------    
    def sePuedeEfificarCasa
      sePuede = false
     
      if(@tituloPropiedad.propietario.class.name == ModeloQytetet::Especulador.class)
        if(@numCasas < 8)
          sePuede = true
        end
      elsif
        @numCasas < 4
        sePuede = true
      end
      sePuede
    end
   
#--------------------------------------------------------------    
    def sePuedeEdificarHotel
       
      sePuede = false
     
      if(@tituloPropiedad.propietario.class.name == ModeloQytetet::Especulador.class)
        if(@numCasas == 4 && @numHoteles < 2)
          sePuede = true
        end
      elsif(@numCasas == 4 && @numHoteles ==0)
        sePuede = true
      end
      sePuede
      
    end
#--------------------------------------------------------------     
      def soyEdificable
       true
      end
#--------------------------------------------------------------    
    def tengoPropietario
      tengo = false
      if @tituloPropiedad.propietario != nil
        tengo = true
      end
      tengo
    end
    
 #--------------------------------------------------------------    
    def venderTitulo
      precioCompra = @coste + (@numCasas+@numHoteles)*@tituloPropiedad.precioEdificar
      precioVenta = precioCompra + @tituloPropiedad.factorRevalorizacion*precioCompra
      
      @tituloPropiedad.propietario = nil
      @numCasas = 0
      @numHoteles = 0
      
      precioVenta
    end
#--------------------------------------------------------------    
    def asignarTituloPropiedad
      @tituloPropiedad.asignarCasilla(self)
    end   
    
#--------------------------------------------------------------     
    def to_s
      super.to_s + " Calle con #{@num_hoteles} hoteles, #{@num_casas} casas y titulo #{@titulo}"
    end

    private :tituloPropiedad= 
  end
  
end

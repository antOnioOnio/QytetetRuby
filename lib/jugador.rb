#encoding: utf-8

require "casilla"
require "titulo_propiedad"
require "qytetet"

module ModeloQytetet
  
  class Jugador
    @@factorEspeculador = 1
    
    attr_accessor :encarcelado, :casillaActual, :propiedades
    attr_accessor :cartaLibertad
    attr_reader :nombre, :saldo
    
    def initialize (nombre)
      
      @nombre = nombre
      @saldo = 7500
      @propiedades = Array.new
      @encarcelado = false 
      @casillaActual = nil 
      @cartaLibertad = nil 
     
    end
    
    def copiaJugador(juga)
      
      @nombre = juga.nombre
      @saldo = juga.saldo
      @propiedades = juga.propiedades
      @encarcelado = juga.encarcelado
      @casillaActual = juga.casillaActual
      @cartaLibertad = juga.cartaLibertad
     
    end
    
    def self.getCasillaActual
      @casillaActual
    end
    
    def convertirme(cant)
      especulador = Especulador.new(self, cant)
      especulador 
    end
    
    
      
#--------------------------------------------------------------     
       
    def tengoPropiedades
      tengo = false
      if @propiedades.empty? != true
        tengo = true 
      end
      tengo
    end
#--------------------------------------------------------------        
    def actualizarPosicion(casilla)
      
      if casilla.numeroCasilla < @casillaActual.numeroCasilla
        
        self.modificarSaldo(Qytetet.getSaldo) 
          
      end
      
      @casillaActual = casilla
      
      tengoPropietario = false
      
      if casilla.soyEdificable == true
        
        tengoPropietario = @casillaActual.tengoPropietario
        
        if tengoPropietario ==true
          
          encarcelado = @casillaActual.propietarioEncarcelado
          
          if encarcelado == false
            
            modificarSaldo(-@casillaActual.cobrarAlquiler)
            
          end
          
        end
        
      elsif casilla.tipo == TipoCasilla::IMPUESTO
          coste = @casillaActual.coste
          modificarSaldo(-coste)
          
      end

     tengoPropietario
      
    end
#--------------------------------------------------------------        
    def comprarTitulo
      puedoComprar = false
      
      if @casillaActual.soyEdificable == true
        if @casillaActual.tengoPropietario == false
          if @casillaActual.coste <= @saldo
            
            titulo = @casillaActual.asignarPropietario(self)
            puedoComprar =true
            @propiedades<<titulo
            modificarSaldo(-@casillaActual.coste)
            
            
          end
        end
      end
      puedoComprar
    end
#--------------------------------------------------------------       
    def devolverCartaLibertad
      aux = @cartaLibertad
      @cartaLibertad=nil
      aux
    end
#--------------------------------------------------------------        
    def irACarcel(casilla)
      @casillaActual=casilla
      @encarcelado = true
    end
#--------------------------------------------------------------       
    def modificarSaldo(cantidad)
      @saldo = @saldo + cantidad
    end
#--------------------------------------------------------------        
    def obtenerCapital()
      capital = @saldo
      
      for propiedad in @propiedades
        valor_propiedad = 0
        num_casa_hoteles =0
        num_casa_hoteles = @casillaActual.numCasas + @casillaActual.numHoteles
        
        if propiedad.casilla.estaHipotecada == false
          
          valor_propiedad = propiedad.casilla.coste +(num_casa_hoteles * propiedad.casilla.precioEdificar)
          capital += valor_propiedad
          
        elsif
          capital = capital- propiedad.hipotecaBase
        end
        
      end
      capital
    end
#--------------------------------------------------------------        
    def obtenerPropiedadesHipotecadas(hipotecada)
      aux = Array.new
      
      if hipotecada == true
        for propiedad in @propiedades
          if propiedad.casilla.estaHipotecada = true
            aux<<propiedad.casilla
          end
        end
        
      elsif
          for propiedad in @propiedades
            if propiedad.casilla.estaHipotecada == false
              aux<<propiedad.casilla
            end
          end
      end
      aux
    end
#--------------------------------------------------------------        
    def pagarCobrarPorCasaYHotel(cantidad)
      
      numeroTotal = cuantasCasasHotelesTengo
      self.modificarSaldo(numeroTotal*cantidad)
      
    end
#--------------------------------------------------------------        
    def pagarLibertad(precioLibertad)
      tengo=false
      
      if tengoSaldo(precioLibertad)
        tengo=true
        self.modificarSaldo(precioLibertad)
      end
      tengo
    end
#--------------------------------------------------------------        
    def puedoEdificarCasa(casilla)
      puedo = false
      esMia = esDeMiPropiedad(casilla)
      costeEdificarCasa = casilla.precioEdificar
      tengoSaldo = tengoSaldo(costeEdificarCasa)
      
      if esMia && tengoSaldo
        puedo = true
      end
      puedo
    end
#--------------------------------------------------------------        
    def puedoEdificarHotel(casilla)
      puedo = false
      esMia = esDeMiPropiedad(casilla)
      costeEdificarHotel = casilla.precioEdificar
      tengoSaldo = tengoSaldo(costeEdificarHotel)
      
      if esMia && tengoSaldo
        puedo = true
      end
      puedo
    end
#--------------------------------------------------------------        
    def puedoHipotecar(casilla)
      puedo = false
      if esDeMiPropiedad(casilla)
        puedo = true
      end
      puedo
    end
#--------------------------------------------------------------        
    def puedoPagarHipoteca(casilla)
      puedo = false
      if puedoHipotecar(casilla)
        dinero = @casillaActual.calcularValorHipoteca
        if @saldo>dinero
          @casillaActual.cancelarHipoteca
          puedo = true
          modificarSaldo(-dinero)
        end
      end
      puedo
    end
#--------------------------------------------------------------        
    def puedoVenderPropiedad(casilla)
      
      puedo = false

       if esDeMiPropiedad(casilla) == true 
         if casilla.estaHipotecada == false
           puedo = true
         end
       end
 
      puedo
    end
#--------------------------------------------------------------        
    def tengoCartaLibertad
      tengo = false
      if @cartaLibertad != nil
        tengo = true
      end
      tengo
    end
#--------------------------------------------------------------        
    def venderPropiedad(casilla)
      precioVenta = casilla.venderTitulo
      modificarSaldo(precioVenta)
      eliminarDeMisPropiedades(casilla)
    end
#--------------------------------------------------------------        
    def cuantasCasasHotelesTengo
      numTotal = 0;
      for propiedad in @propiedades
        numTotal += propiedad.casilla.numCasas
        numTotal += propiedad.casilla.numHoteles
      end
    
      numTotal
    end
#--------------------------------------------------------------        
    def eliminarDeMisPropiedades(casilla)
      if esDeMiPropiedad(casilla)
        @propiedades.delete(casilla.tituloPropiedad)
      end
      casilla.asignarPropietario(nil);
    end
#--------------------------------------------------------------        
    def esDeMiPropiedad(casilla)
      es = false
      for propiedad in @propiedades
        if propiedad.casilla == casilla
          es = true
        end
      end
      es
    end
#--------------------------------------------------------------        
    def tengoSaldo(cantidad)
      tengo = false
      if @saldo > cantidad
        tengo = true
      end
      tengo
    end
#--------------------------------------------------------------        
    def to_s
      "Nombre : #{@nombre} \n Saldo: #{@saldo} \n CasillaActual : #{@casillaActual.numeroCasilla} \n"
    end
#--------------------------------------------------------------      
    private :cuantasCasasHotelesTengo, :eliminarDeMisPropiedades, :esDeMiPropiedad
    
  end
end

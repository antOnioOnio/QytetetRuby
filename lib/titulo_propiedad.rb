#encoding: utf-8

module ModeloQytetet
  
  class TituloPropiedad
    
    attr_reader  :nombre, :alquilerBase, :factorRevalorizacion, :hipotecaBase, :precioEdificar
    attr_accessor  :hipotecada, :propietario , :casilla
     
    
    def initialize(nombre,alquiler,factorRev,hipbase,precioEd) 
      @nombre = nombre
      @alquilerBase = alquiler
      @factorRevalorizacion = factorRev
      @hipotecaBase = hipbase
      @precioEdificar = precioEd
      @hipotecada = false
      @propietario = nil 
      @casilla = nil
    end
    
#--------------------------------------------------------------   
    def to_s
       "Nombre: #{@nombre} \n Alquiler base: #{@alquilerBase} \n Factor de revalorizacion: #{@factorRevalorizacion} \n Hipoteca base: #{@hipotecaBase} \n Precio edificar: #{@precioEdificar} \n "
    end
#--------------------------------------------------------------    
    def cobrarAlquiler(coste)
      @propietario.modificarSaldo(coste)
    end
#--------------------------------------------------------------    
    def propietarioEncarcelado
      encarcelado = false
      if @propietario.encarcelado == true
        encarcelado = true
      end
      encarcelado
    end
    
    def asignarCasilla(casi)
      @casilla = casi
    end
#--------------------------------------------------------------    
    def tengoPropietario
      tengo = true
      if @propietario == nil
        tengo = false
      end
      tengo
    end
#--------------------------------------------------------------    
  end
end
 
#encoding: utf-8

require 'sorpresa'
require 'tipo_sorpresa'
require 'casilla'
require 'tipo_casilla'
require 'titulo_propiedad'
require 'calle'

module ModeloQytetet
  
  class Tablero 
    
    attr_reader :carcel, :casillas
    
    def initialize()
      @casillas=Array.new #ponle el tamaño 
      @carcel  
      inicializar()
    end
#-------------------------------------------------------------------------------  
    def inicializar()
      
      @casillas<<Casilla.new(0,0,TipoCasilla::SALIDA)
      @casillas<<Casilla.new(1,0,TipoCasilla::SORPRESA)     
      #BARRIO DE CLASE MEDIA
      @casillas<<Calle.new(2,450,TituloPropiedad.new("Calle del camarero",65,20,200,300))
      @casillas<<Calle.new(3,450,TituloPropiedad.new("Avenida del obrero",65,20,200,300))
      @casillas<<Calle.new(4,450,TituloPropiedad.new("Calle del electricista",65,20,200,300))
      @casillas<<Casilla.new(5,0,TipoCasilla::PARKING)
      #BARRIO POBRΩE
      @casillas<<Calle.new(6,375,TituloPropiedad.new("Calle del pordiosero",50,10,150,250))
      @casillas<<Calle.new(7,375,TituloPropiedad.new("Camino del ladron",50,10,150,250))
      
      @carcel= Casilla.new(8,0,TipoCasilla::CARCEL)
      @casillas<<@carcel
      @casillas<<Calle.new(9,375,TituloPropiedad.new("Calle del expresidiario",50,10,150,250))
      #Barrio de clase alta
      @casillas<<Calle.new(10,600,TituloPropiedad.new("Avenida del presidente",75,12,400,500))
      @casillas<<Calle.new(11,600,TituloPropiedad.new("Camino del doctor Ochoa",75,12,400,500))
      @casillas<<Casilla.new(12,0,TipoCasilla::IMPUESTO)
      @casillas<<Calle.new(13,600,TituloPropiedad.new("Calle del duque",75,12,400,500))
      @casillas<<Casilla.new(14,0,TipoCasilla::SORPRESA)
      #Barrio ricos
      @casillas<<Calle.new(15,650,TituloPropiedad.new("Via del Rey",100,10,700,750))
      @casillas<<Casilla.new(16,0,TipoCasilla::JUEZ)
      @casillas<<Calle.new(17,650,TituloPropiedad.new("Avenida de los condeses",100,10,700,750))
      @casillas<<Casilla.new(18,0,TipoCasilla::SORPRESA)
      @casillas<<Calle.new(19,650,TituloPropiedad.new("Calle de Don Roquefeller",100,10,700,750))
         
    end
#-------------------------------------------------------------------------------    
    def esCasillaCarcel(numeroCasilla)
      es = false
      if @casillas[numeroCasilla].tipo == TipoCasilla::CARCEL
        es = true
      end
      es
    end
#-------------------------------------------------------------------------------    
    def obtenerCasillaNumero(numCasilla)
      numCasilla %= 20
      @casillas[numCasilla]
    end
#-------------------------------------------------------------------------------    
    def obtenerNuevaCasilla(casilla,desplazamiento)
      @casillas[((casilla.numeroCasilla)+desplazamiento)%19]
    end
#-------------------------------------------------------------------------------    
    def to_s
      var = ""      
      for casilla in @casillas           
        var += casilla.to_s 
      end
     var
    end
#-------------------------------------------------------------------------------     
  end
end

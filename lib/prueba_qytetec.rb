##encoding: utf-8
#
#
#require 'sorpresa'
#require 'tipo_sorpresa'
#require 'casilla'
#require 'tipo_casilla'
#require 'titulo_propiedad'
#require 'tablero'
#require 'qytetet'
#
#
#module ModeloQytetet 
# 
#  class PruebaQytetec
## 
##
##    @@mazo= Array.new
##    def self.inicializar_sorpresas()
##        @@mazo<<Sorpresa.new("Lastima, tus acciones acaban de caer y pierdes 200 euros", -200, TipoSorpresa::PAGARCOBRAR);
##        @@mazo<<Sorpresa.new("Hoy es tu dia de suerte, ha llegado el sobre de tu abuela con 200 euros", 200, TipoSorpresa::PAGARCOBRAR);
##        @@mazo<<Sorpresa.new("Te hemos pillado evadiendo impuestos, ¡debes ir a la carcel!", 8, TipoSorpresa::IRACASILLA);
##        @@mazo<<Sorpresa.new("Ve al parking a meditar sobre la vida", 6, TipoSorpresa::IRACASILLA);
##        @@mazo<<Sorpresa.new("Subete a mi coche que te voy a dejar 5 casillas mas adelante", +5, TipoSorpresa::IRACASILLA);
##        @@mazo<<Sorpresa.new("Ha llegado la declaracion de la renta y te sale a devolver por cada propiedad 100 euros", +100, TipoSorpresa::PORCASAHOTEL);
##        @@mazo<<Sorpresa.new("Hacienda ha llamado, tienes que pagar por tus propiedades 100 euros", -100, TipoSorpresa::PORCASAHOTEL);
##        @@mazo<<Sorpresa.new("Todos los jugadores tienen que pagarte 100 euros ! ", 100, TipoSorpresa::PORJUGADOR);
##        @@mazo<<Sorpresa.new("Ups, mala suerte, pagas 50 euros a todos los concursantes", 50, TipoSorpresa::PORJUGADOR);
##        @@mazo<<Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel", 0, TipoSorpresa::SALIRCARCEL);   
##    end
##    
##    def self.sorpresasmayorque0()
##      nmazo = Array.new  
##      for s in @@mazo    
##        if s.valor > 0 
##          nmazo << s 
##        end   
##      end 
##      return nmazo;  
##    end
##    
##    def self.sorpresairacasilla()
##      nmazo = Array.new
##      for s in @@mazo
##        if s.tipo == TipoSorpresa::IRACASILLA
##          nmazo << s 
##        end
##      end
##      return nmazo;
##    end
##    
##    def self.sorpresaespecificado(tipo)
##      
##      nmazo = Array.new
##      
##      for s in @@mazo
##        if s.tipo == tipo 
##          nmazo << s 
##        end
##      end
##      return nmazo;
##    end
##    
##    def self.enseniaelomazo
##      
##      for s in @@mazo
##        puts s
##      end
##      
##    end
##  
##    
# #   def self.main()
#      
#      #@jugador = Jugador.new("paco")
#      #puts @jugador
#      #@tablero = Tablero.new
#      #puts @tablero.to_s
##      
##      juego = Qytetet.instance
##      puts  juego.obtenerRanking
##     
##      nombres = Array.new
##      nombres<<"paco"
##      nombres<<"antonio"
##      nombres<<"victor"
##      juego.inicializarJugadores(nombres)
##      
##      puts juego.to_s
##      
#       
##      tab=Tablero.new
##      inicializar_sorpresas()
##      puts sorpresasmayorque0()
##      enseniaelmazo
##      puts sorpresairacasilla()
##      puts sorpresaespecificado(TipoSorpresa::SALIRCARCEL)
##      puts tab.to_s
##      
#    end
#    
#  end
#  #PruebaQytetec.main()
#end
#

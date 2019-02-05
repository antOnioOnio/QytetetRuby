#enconding: utf-8

require 'metodo_salir_carcel'
require 'sorpresa'
require 'tipo_sorpresa'
require 'casilla'
require 'tipo_casilla'
require 'titulo_propiedad'
require 'tablero'
require 'singleton'
require 'jugador'
require 'dado'
require 'especulador'
module ModeloQytetet
  
  class Qytetet
    
    include Singleton
    
    attr_reader :cartaActual, :jugadorActual
       #Variables globales???? 
       @@MAX_JUGADORES = 4
       @@MAX_CARTAS = 10
       @@MAX_CASILLAS = 20
       @@PRECIO_LIBERTAD = 200
       @@SALDO_SALIDA = 1000 
#--------------------------------------------------------------    
    def initialize()
     
       @metodoSalir 
       @cartaActual 
       @mazo = Array.new
       @jugadores = Array.new
       @jugadorActual 
       @tablero 
       @dado = Dado.instance
       
       #inicializarJuego(nombres)
       
    end
#--------------------------------------------------------------    
    def self.getSaldo
      @@SALDO_SALIDA
    end
#--------------------------------------------------------------    
    def self.getPrecioLibertad
      @@PRECIO_LIBERTAD
    end
#--------------------------------------------------------------    
    def to_s
      "Jugadores\n #{@jugadores} \n\n Tablero\n #{@tablero} \n\n Cartas Sorpresa\n #{@mazo}"
    end
#--------------------------------------------------------------  
   def inicializarCartasSorpresa
        @mazo<<Sorpresa.new("Te conviertes en especulador. ", 500, TipoSorpresa::CONVERTIR)
        @mazo<<Sorpresa.new("Lastima, tus acciones acaban de caer y pierdes 200 euros", -200, TipoSorpresa::PAGARCOBRAR);
        @mazo<<Sorpresa.new("Hoy es tu dia de suerte, ha llegado el sobre de tu abuela con 200 euros", 200, TipoSorpresa::PAGARCOBRAR);
        @mazo<<Sorpresa.new("Te hemos pillado evadiendo impuestos, ¡debes ir a la carcel!", 8, TipoSorpresa::IRACASILLA);
        @mazo<<Sorpresa.new("Ve al parking a meditar sobre la vida", 6, TipoSorpresa::IRACASILLA);
        @mazo<<Sorpresa.new("Subete a mi coche que te voy a dejar 5 casillas mas adelante", 5, TipoSorpresa::IRACASILLA);
        @mazo<<Sorpresa.new("Ha llegado la declaracion de la renta y te sale a devolver por cada propiedad 100 euros", +100, TipoSorpresa::PORCASAHOTEL);
        @mazo<<Sorpresa.new("Hacienda ha llamado, tienes que pagar por tus propiedades 100 euros", -100, TipoSorpresa::PORCASAHOTEL);
        @mazo<<Sorpresa.new("Todos los jugadores tienen que pagarte 100 euros ! ", 100, TipoSorpresa::PORJUGADOR);
        @mazo<<Sorpresa.new("Ups, mala suerte, pagas 50 euros a todos los concursantes", 50, TipoSorpresa::PORJUGADOR);
        @mazo<<Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel", 0, TipoSorpresa::SALIRCARCEL);   
        
        #@mazo.shuffle
    end
#--------------------------------------------------------------    
   def inicializarJugadores(jugadores)
     
     for s in jugadores
       @jugadores<<Jugador.new(s)
     end
     
   end
#--------------------------------------------------------------   
   def inicializarTablero
     @tablero = Tablero.new
   end
#--------------------------------------------------------------   
   def aplicarSorpresa
      tienePropietario = false;
          
          if @cartaActual.tipo == TipoSorpresa::PAGARCOBRAR
              puts " Carta cogida es de tipo pagar cobrar "
              @jugadorActual.modificarSaldo(@cartaActual.valor)
          
          elsif @cartaActual.tipo == TipoSorpresa::IRACASILLA
              puts " Carta cogida es de tipo ir a casilla"
              if @tablero.esCasillaCarcel(@cartaActual.valor)
                  puts " Has caido en la carcel"
                  encarcelarJugador
              
              else
                  
                  nuevaCasilla = @tablero.obtenerCasillaNumero(@cartaActual.valor);
                  puts "Has ido a parar a la casilla numero #{nuevaCasilla.numeroCasilla}"
                  tienePropietario = @jugadorActual.actualizarPosicion(nuevaCasilla);
              end
          
          elsif @cartaActual.tipo ==TipoSorpresa::PORCASAHOTEL
              puts " Has cogido la carta por casa hotel"
              @jugadorActual.pagarCobrarPorCasaYHotel(@cartaActual.valor)
          
          elsif @cartaActual.tipo ==TipoSorpresa::PORJUGADOR
              
              
              for jugador in @jugadores 
                  if jugador != @jugadorActual
                      if  @cartaActual.valor>0
                          puts "Carta cogida es porjugador, pero buena"
                          @jugadorActual.modificarSaldo(@cartaActual.valor);
                          jugador.modificarSaldo(-@cartaActual.valor);
                      
                      else
                          puts "Carta cogida es porjugador, pero buena"
                          @jugadorActual.modificarSaldo(-@cartaActual.valor)
                          jugador.modificarSaldo(@cartaActual.valor)
                      end
                  end
              end
          
          
          elsif @cartaActual.tipo == TipoSorpresa::SALIRCARCEL
              puts " Carta cogida es la de salir de la carcel"
              @jugadorActual.cartaLibertad = @cartaActual
              @mazo<<@cartaActual
          
          elsif @cartaActual.tipo == TipoSorpresa::CONVERTIR
             pos = @jugadores.index(@jugadorActual)
             @jugadorActual = @jugadorActual.convertirme(@cartaActual.valor)
             @jugadores[pos]= @jugadorActual
            
          end
          
   
      
         tienePropietario;
    end
#--------------------------------------------------------------   
   def cancelarHipoteca(casilla)
     @jugadorActual.puedoPagarHipoteca(casilla)
   end
#--------------------------------------------------------------   
   def comprarTituloPropiedad
     return @jugadorActual.comprarTitulo
   end
#--------------------------------------------------------------   
   def edificarCasa(casilla)
     
     puedoEdificar = false
     
     if casilla.soyEdificable == true
       if casilla.sePuedeEfificarCasa == true
         puedoEdificar = @jugadorActual.puedoEdificarCasa(casilla)
         if puedoEdificar == true
           costeEdificarCasa = casilla.edificarCasa
           @jugadorActual.modificarSaldo(-costeEdificarCasa)
         end
       end
     end
   
     puedoEdificar
   end
#--------------------------------------------------------------   
   def edificarHotel(casilla)
     puedoEdificar = false
     if casilla.soyEdificable
       if casilla.sePuedeEdificarHotel
         puedoEdificar = @jugadorActual.puedoEdificarHotel(casilla);
         if puedoEdificar
           costeEdificarHotel = casilla.edificarHotel
           @jugadorActual.modificarSaldo(-costeEdificarHotel)
         end
       end
     end
     puedoEdificar
   end
#--------------------------------------------------------------   
   def hipotecarPropiedad(casilla)
     puedoHipotecar = false
     
     if casilla.soyEdificable
       sePuedeHipotecar = !casilla.estaHipotecada
       if sePuedeHipotecar
         puedoHipotecar = @jugadorActual.puedoHipotecar(casilla)
         if puedoHipotecar
           cantidadRecibida =casilla.hipotecar
         end
       end
     end
     puedoHipotecar
   end
#--------------------------------------------------------------   
   def inicializarJuego(nombres)
     
       inicializarJugadores(nombres)
       inicializarCartasSorpresa
       inicializarTablero
       salidaJugadores

   end
#--------------------------------------------------------------   
   def intentarSalirCarcel(metodo)
     libre = false
     
     if metodo == MetodoSalirCarcel::TIRANDODADO 
       valorDado = @dado.tirar
       if valorDado > 5
         libre = true
       end
     elsif metodo == MetodoSalirCarcel::PAGANDOLIBERTAD
       cantidad = -Qytetet.getPrecioLibertad
       tengoSaldo = @jugadorActual.pagarLibertad(cantidad)
       libre = tengoSaldo
     end
     if libre
       @jugadorActual.encarcelado = false
     end
     libre
   end  
#--------------------------------------------------------------   
   def jugar
     tienePropietario = false
     valorDado = @dado.tirar
     puts "Valor de la tirada #{ valorDado} "
     casillaPosicion = @jugadorActual.casillaActual
     nuevaCasilla = @tablero.obtenerNuevaCasilla(casillaPosicion, valorDado)
     puts "Ha caido en la casilla numero #{nuevaCasilla.numeroCasilla} de tipo #{nuevaCasilla.tipo}" 
     tienePropietario = @jugadorActual.actualizarPosicion(nuevaCasilla)
     
     if !nuevaCasilla.soyEdificable
       if nuevaCasilla.tipo == TipoCasilla::JUEZ
         encarcelarJugador
       elsif nuevaCasilla.tipo == TipoCasilla::SORPRESA
         @cartaActual = @mazo[0]
         @mazo.delete_at(0)
         @mazo<<@cartaActual
       end
     end
     
     tienePropietario
   end
#--------------------------------------------------------------   
   def obtenerRanking
     ranking = Array.new
     for j in @jugadores
       ranking << j.nombre + " " + j.saldo.to_s
     end
     ranking
   end
#--------------------------------------------------------------   
   def propiedadesHipotecadasJugador(hipotecadas)
     @jugadorActual.obtenerPropiedadesHipotecadas(hipotecadas)
   end
#--------------------------------------------------------------   
   def siguienteJugador
     pos = (@jugadores.index(@jugadorActual)+1)%((@jugadores.size))
     @jugadorActual  = @jugadores.at(pos)
     @jugadorActual
   end
#--------------------------------------------------------------   
   def venderPropiedad(casilla)
     puedoVender = false
     puedoVender = @jugadorActual.puedoVenderPropiedad(casilla)
     
     if casilla.soyEdificable && puedoVender
       @jugadorActual.venderPropiedad(casilla)
     end
     
    puedoVender 
   end
#--------------------------------------------------------------   
   def encarcelarJugador  
     casillaCarcel = nil   
     if  @jugadorActual.tengoCartaLibertad
       casillaCarcel = @tablero.carcel
       @jugador.irACarcel(casillaCarcel)
     else
       carta = @jugadorActual.devolverCartaLibertad
       @mazo<<carta
     end 
   end
#--------------------------------------------------------------   
   def salidaJugadores
     
     for jugador in @jugadores
       jugador.casillaActual = @tablero.obtenerCasillaNumero(0) 
     end
     @jugadorActual = @jugadores.at(rand(@jugadores.size))
   end
#--------------------------------------------------------------   
 
  private :inicializarCartasSorpresa, :inicializarTablero, :salidaJugadores
   
end
   
    
  
end

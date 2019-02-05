#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require "qytetet"
require "vista_textual_qytetet"

module InterfazTextualQytetet
  class ControladorQytetet
    attr_reader :vista
    
    def initialize
      
      @juego
      @jugador
      @casilla
      @vista = VistaTextualQytetet.new
      
    end
    
    
    def desarrollar_juego
      bancarrota = false
      libre = !@jugador.encarcelado
      opcion = -1
      propiedades = Array.new
      
      loop do   
        if !libre
          metodo = @vista.menu_salir_carcel
          if metodo == 0
            libre = @juego.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::TIRANDODADO)
            
          elsif metodo == 1
            libre = @juego.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::PAGANDOLIBERTAD)
          end
        end
        if libre
          
          noTienePropietario = @juego.jugar
          bancarrota = !@jugador.tengoSaldo(0)
          
          if !bancarrota && !@jugador.encarcelado
           
            if @jugador.casillaActual.tipo == ModeloQytetet::TipoCasilla::SORPRESA
             
              noTienePropietario = @juego.aplicarSorpresa
              if !@jugador.encarcelado
               
                bancarrota = !@jugador.tengoSaldo(0)
                if !bancarrota && @jugador.casillaActual.tipo == ModeloQytetet::TipoCasilla::CALLE
                  
                  if !@jugador.casillaActual.tengoPropietario
                    
                    if @vista.elegir_quiero_comprar
                      
                      @juego.comprarTituloPropiedad
                      
                    end
                  end
                  
                end
              end
            elsif @jugador.casillaActual.tipo == ModeloQytetet::TipoCasilla::CALLE
              
              if !@jugador.casillaActual.tengoPropietario
               
                if @vista.elegir_quiero_comprar
                 
                  @juego.comprarTituloPropiedad
                end
              end
            end
         
          bancarrota = !@jugador.tengoSaldo(0)
          
          if !@jugador.encarcelado && !bancarrota && @jugador.tengoPropiedades
          
            loop do
              opcion = @vista.menu_gestion_inmobiliaria
              if opcion == 5
                casillaJugador = elegir_propiedad(@jugador.obtenerPropiedadesHipotecadas(true))
                @juego.cancelarHipoteca(casillaJugador)
                
              elsif opcion != 0
                
                casillaJugador = elegir_propiedad(@jugador.obtenerPropiedadesHipotecadas(false))
                if opcion == 4
                  @juego.hipotecarPropiedad(casillaJugador)
                elsif opcion == 3
                  @juego.venderPropiedad(casillaJugador)
                elsif opcion == 2
                  @juego.edificarHotel(casillaJugador)
                elsif opcion == 1
                  @juego.edificarCasa(casillaJugador)
                end
              end
              break if opcion>0 && opcion<=5 
            end
          end
          end
          
        end
        bancarrota = !@jugador.tengoSaldo(0)
        
        if !bancarrota
          
          @jugador = @juego.siguienteJugador
          puts "\n"
          puts "=======" + "jugador Actual" + "========"
          puts @jugador.to_s 
        end
        break if bancarrota
      end
      
      @juego.obtenerRanking
    end
    
    
    
    def inicialiacion_juego
      @juego = ModeloQytetet::Qytetet.instance
      nombres = vista.obtener_nombre_jugadores
      @juego.inicializarJuego(nombres)
      @jugador = @juego.jugadorActual
      @casilla = @juego.jugadorActual.casillaActual
      puts @juego.to_s
      puts "======" + "Jugador Actual   ====="
      puts @jugador.to_s
      gets.chomp 
    end
    
    
    def self.main 
      controlador = ControladorQytetet.new 
      controlador.inicialiacion_juego
      controlador.desarrollar_juego
      
    end
    
    
    def elegir_propiedad(propiedades) # lista de propiedades a elegir
        @vista.mostrar("\tCasilla\tTitulo");
        
        listaPropiedades= Array.new
        for prop in propiedades  # crea una lista de strings con numeros y nombres de propiedades
                 propString= prop.numeroCasilla.to_s + ' '+ prop.tituloPropiedad.nombre

                listaPropiedades<<propString
        end
        seleccion=@vista.menu_elegir_propiedad(listaPropiedades)  # elige de esa lista del menu
        propiedades.at(seleccion)
    end

  end
  ControladorQytetet.main
  
end

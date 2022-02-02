
%Nombre: Apellido, Nombre
%Legajo: 167778-0

laVerdad.

%1. Modelar los jugadores y elementos y agregarlos a la base de conocimiento, utilizando los ejemplos provistos.

%tieneElemento(Jugador,Elemento).
tieneElemento(ana,vapor).
tieneElemento(ana,hierro).
tieneElemento(ana,tierra).
tieneElemento(ana,agua).

tieneElemento(beto,Elemento):-
	tieneElemento(ana,Elemento).

tieneElemento(cata,fuego).
tieneElemento(cata,aire).
tieneElemento(cata,tierra).
tieneElemento(cata,agua).

haceFaltaParaConstruir(pasto,agua).
haceFaltaParaConstruir(pasto,tierra).

haceFaltaParaConstruir(hierro,fuego).
haceFaltaParaConstruir(hierro,agua).
haceFaltaParaConstruir(hierro,tierra).

haceFaltaParaConstruir(huesos,pasto).
haceFaltaParaConstruir(huesos,agua).

haceFaltaParaConstruir(vapor,agua).
haceFaltaParaConstruir(vapor,fuego).

haceFaltaParaConstruir(presion,hierro).
haceFaltaParaConstruir(presion,vapor).
	
haceFaltaParaConstruir(playstation,silicio).
haceFaltaParaConstruir(playstation,hierro).
haceFaltaParaConstruir(playstation,plastico).

haceFaltaParaConstruir(silicio,tierra).

haceFaltaParaConstruir(plastico,huesos).
haceFaltaParaConstruir(plastico,presion).


% Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
% Las cucharas tienen una longitud en cms.
% Hay distintos tipos de libro.
				%circulo(Diametro,Niveles).
herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).




%2. Saber si un jugador ​ tieneIngredientesPara construir un elemento, que es cuando tiene en su inventario todo lo que hace falta. 
	%Por ejemplo, ana tiene los ingredientes para el pasto, pero no para el vapor.

tieneIngredientesPara(Jugador,Elemento):-
	tieneElemento(Jugador,_),
	haceFaltaParaConstruir(Elemento,_),
	forall(haceFaltaParaConstruir(Elemento,ElementoFaltante), tieneElemento(Jugador,ElementoFaltante)).




%3. Saber si un elemento ​ estaVivo​ . Se sabe que el agua, el fuego y todo lo que fue construido a partir de ellos, 
	%están vivos. Debe funcionar para cualquier nivel.
	%Por ejemplo, la play station está viva, pero el silicio no.

estaVivo(agua).
estaVivo(fuego).

estaVivo(Elemento):-
	haceFaltaParaConstruir(Elemento,agua).
estaVivo(Elemento):-
	haceFaltaParaConstruir(Elemento,fuego).

estaVivo(Elemento):-
	haceFaltaParaConstruir(Elemento,ElementoFaltante),
	estaVivo(ElementoFaltante).




%4. Conocer las personas que ​ puedeConstruir un elemento, para lo que se necesita tener los ingredientes y además 
	%contar con una o más herramientas que sirvan para construirlo. 

	%Para los elementos vivos sirve el libro de la vida (y para los elementos no vivos el libro inerte). 
	%Además, las cucharas y círculos sirven cuando soportan la cantidad de ingredientes del elemento 

	%las cucharas soportan tantos ingredientes como centímetros/10, 
	%los círculos alquímicos soportan tantos ingredientes como metros * cantidad de niveles.

 	%Por ejemplo, beto puede construir el silicio (porque tiene tierra y tiene el libro inerte, que le sirve para el 
 	%silicio), pero no puede construir la presión (porque a pesar de tener hierro y vapor, no cuenta con herramientas 
 	%que le sirvan para la presión). 
 	%Ana, por otro lado, sí puede construir silicio y presión.

 puedeConstruir(Jugador,Elemento):-
 	tieneIngredientesPara(Jugador,Elemento),
 	cuentaConHerramientasParaConstruir(Jugador,Elemento).

 cuentaConHerramientasParaConstruir(Jugador,Elemento):-
 	tieneElemento(Jugador,_),
 	haceFaltaParaConstruir(Elemento,_),
 	findall(Herramienta,herramientaQuePoseeParaConstruir(Jugador,Elemento,Herramienta),Herramientas),
 	length(Herramientas,Cantidad),
 	Cantidad >= 1.

herramientaQuePoseeParaConstruir(Jugador,Elemento,Herramienta):-
	herramienta(Jugador,Herramienta),
	sirveParaConstruir(Elemento,Herramienta).

sirveParaConstruir(Elemento,libro(vida)):-
	estaVivo(Elemento).

sirveParaConstruir(Elemento,libro(inerte)):-
	haceFaltaParaConstruir(Elemento,_),
	not(estaVivo(Elemento)). 

sirveParaConstruir(Elemento,cuchara(Longitud)):-
	soportaIngredientes(Elemento,cuchara(Longitud)).
							
sirveParaConstruir(Elemento,circulo(Diametro,Niveles)):-
	soportaIngredientes(Elemento,circulo(Diametro,Niveles)).


soportaIngredientes(Elemento,cuchara(Longitud)):-
	cantidadIngredientesParaConstruir(Elemento,CantidadIngredientes),
	CantidadIngredientes is Longitud/10.

soportaIngredientes(Elemento,circulo(Diametro,Niveles)):-
	cantidadIngredientesParaConstruir(Elemento,CantidadIngredientes),
	CantidadIngredientes is Diametro/100*Niveles.

cantidadIngredientesParaConstruir(Elemento,Cantidad):-
	haceFaltaParaConstruir(Elemento,_),
	findall(Ingrediente,haceFaltaParaConstruir(Elemento,Ingrediente),Ingredientes),  
	length(Ingredientes,Cantidad).





%5. Saber si alguien es ​ todopoderoso​ , que es cuando tiene todos los elementos primitivos
	%(los que no pueden construirse a partir de nada)
	%además cuenta con herramientas que sirven para construir cada elemento que no tenga.
	%Por ejemplo, cata es todopoderosa, pero beto no.

todoPoderoso(Jugador):-
	tieneElementosPrimitivos(Jugador),
	cuentaConHerramientasParaConstruirElementoFaltante(Jugador).

tieneElementosPrimitivos(Jugador):-
	tieneElemento(Jugador,_),
	forall(elementoPrimitivo(Elemento), tieneElemento(Jugador,Elemento)).

elementoPrimitivo(Elemento):-
	tieneElemento(_,Elemento),
	not(haceFaltaParaConstruir(Elemento,_)).

cuentaConHerramientasParaConstruirElementoFaltante(Jugador):-
	herramienta(Jugador,_),
	forall( not(tieneElemento(Jugador,ElementoFaltante)),cuentaConHerramientasParaConstruir(Jugador,ElementoFaltante)).





%6. Conocer ​ quienGana​ , que es quien puede construir más cosas.
	%Por ejemplo, cata gana, pero beto no.

quienGana(Jugador):-
	construyeMas(Jugador). 

construyeMas(Jugador):-
	tieneElemento(Jugador,_),
	cantidadDeElementosQueConstruye(Jugador,Cantidad),
	forall((cantidadDeElementosQueConstruye(OtroJugador,OtraCantidad),OtroJugador \= Jugador), Cantidad > OtraCantidad).
 
cantidadDeElementosQueConstruye(Jugador,Cantidad):-
	puedeConstruir(Jugador,_),
	findall(Elemento,puedeConstruir(Jugador,Elemento),Elementos),
	length(Elementos,Cantidad).



/*7. Mencionar un lugar de la solución donde se haya hecho uso del concepto de universo cerrado.

	Al modelar la base de conocimientos en el punto 1, se menciona que Cata no tiene el elemento "vapor",
	Es por esto que gracias al concepto de universo cerrado, no hace falta escribir esa regla.
	No hace falta escribir que Cata No tiene "vapor", ya que todo lo que no esta, se considera falso.

*/

/*8. Hacer una nueva versión del predicado ​ puedeConstruir ​ (se puede llamar
puedeLlegarATener​ ) para considerar todo lo que podría construir si va combinando
todos los elementos que tiene (y siempre y cuando tenga alguna herramienta que le
sirva para construir eso). Un jugador puede llegar a tener un elemento si o bien lo tiene,
o bien tiene alguna herramienta que le sirva para hacerlo y cada ingrediente necesario
para construirlo puede llegar a tenerlo a su vez.
Por ejemplo, cata podría llegar a tener una play station, pero beto no ​.*/


puedeLlegarATener(Jugador,Elemento):-
	tieneElemento(Jugador,Elemento).
puedeLlegarATener(Jugador,Elemento):-
	cuentaConHerramientasParaConstruir(Jugador,Elemento),
	forall(haceFaltaParaConstruir(Elemento,ElementoFaltante),puedeLlegarATener(Jugador,ElementoFaltante)).



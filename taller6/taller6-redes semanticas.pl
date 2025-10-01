% Grupos principales de alimentos
es_un(carne, alimento).
es_un(grasa, alimento).
es_un(lacteo, alimento).
es_un(fruta, alimento).
es_un(vegetal, alimento).
es_un(cereal, alimento).
es_un(legumbre, alimento).

% Carnes (6 instancias)
inst(res, carne).
inst(vaca, carne).
inst(pollo, carne).
inst(pavo, carne).
inst(pescado, carne).
inst(conejo, carne).

% Lácteos (6 instancias)
inst(queso, lacteo).
inst(yogurt, lacteo).
inst(leche, lacteo).
inst(mantequilla, lacteo).
inst(helado, lacteo).
inst(cuajada, lacteo).

% Frutas (6 instancias)
inst(banana, fruta).
inst(manzana, fruta).
inst(naranja, fruta).
inst(uva, fruta).
inst(fresa, fruta).
inst(mango, fruta).

% Vegetales (6 instancias)
inst(apio, vegetal).
inst(guisante, vegetal).
inst(lechuga, vegetal).
inst(cebolla, vegetal).
inst(zanahoria, vegetal).
inst(calabacin, vegetal).

% Cereales (6 instancias)
inst(trigo, cereal).
inst(arroz, cereal).
inst(maiz, cereal).
inst(cebada, cereal).
inst(avena, cereal).
inst(ajonjoli, cereal).

% Legumbres (6 instancias)
inst(papa, legumbre).
inst(yuca, legumbre).
inst(garbanzos, legumbre).
inst(lentejas, legumbre).
inst(arbejas, legumbre).
inst(porotos, legumbre).

% Grasas (6 instancias)
inst(aceite_de_oliva, grasa).
inst(margarina, grasa).
inst(aceite_de_girasol, grasa).
inst(aceite_de_coco, grasa).
inst(aceite_de_soya, grasa).
inst(mantequilla_de_mani, grasa).

% Propiedades generales de alimento (clase raiz)
prop(alimento, tiene_proteina, si).
prop(alimento, comestible, si).
prop(alimento, tiene_carbohidratos, si).
prop(alimento, tiene_calorias, si).
prop(alimento, es_perecedero, si).
prop(alimento, tiene_azucar, si).
prop(alimento, tiene_agua, si).
prop(alimento, son_transgenicos, si).

% Propiedades especificas de carnicos
prop(carne, proviene_de_animal, si).
prop(carne, facil_de_digerir, si).
prop(carne, tiene_grasas, si).
prop(carne, rica_en_nutrientes, si).
prop(carne, tiene_azucar, no).           % Override de alimento
prop(carne, contiene_fibra, no).
prop(carne, contiene_colageno, si).
prop(carne, tiene_carbohidratos, no).    % Override de alimento

% Propiedades especificas de grasas
prop(grasa, son_insaturadas, no).
prop(grasa, son_saturadas, si).
prop(grasa, son_trans, si).
prop(grasa, son_grasas_saludables, si).
prop(grasa, pueden_consumir_crudo, si).
prop(grasa, aptas_para_cocer, si).
prop(grasa, olor_agradable, no).
prop(grasa, soluble_en_agua, no).

% Propiedades especificas de lacteos
prop(lacteo, tiene_lactosa, si).
prop(lacteo, textura_cremosa, si).
prop(lacteo, son_blancos, si).
prop(lacteo, origen_animal, si).
prop(lacteo, baja_fibra, si).
prop(lacteo, tiene_colageno, no).
prop(lacteo, facil_digestion, no).
prop(lacteo, proviene_de_plantas, no).

% Propiedades especificas de cereales
prop(cereal, alta_fibra, si).
prop(cereal, ricos_en_minerales, si).
prop(cereal, tienen_vitaminas, si).
prop(cereal, propiedades_antiinflamatorias, no).
prop(cereal, son_amarillos, si).
prop(cereal, tienen_carbohidratos, si).  % Refuerzo de alimento
prop(cereal, tienen_agua, no).           % Override de alimento
prop(cereal, tienen_electrolitos, no).

% Propiedades especificas de legumbres
prop(legumbre, alto_en_fibra, si).
prop(legumbre, tienen_proteina, si).     % Refuerzo de alimento
prop(legumbre, alto_en_minerales, si).
prop(legumbre, son_amarronados, si).
prop(legumbre, provienen_de_la_tierra, si).
prop(legumbre, tiene_agua, no).          % Override de alimento
prop(legumbre, tiene_azucar, no).        % Override de alimento
prop(legumbre, provienen_de_animal, no).

% Propiedades especificas de frutas
prop(fruta, provienen_de_plantas, si).
prop(fruta, tienen_semillas, si).
prop(fruta, ricas_en_vitaminas, si).
prop(fruta, facil_de_digerir, si).
prop(fruta, bajo_aporte_calorico, si).
prop(fruta, contiene_fibras, si).
prop(fruta, tiene_agua, si).             % Refuerzo de alimento
prop(fruta, contienen_azucares, si).

% Propiedades especificas de vegetales
prop(vegetal, son_verdes, si).
prop(vegetal, recomendable_cocinar, no).
prop(vegetal, tienen_olor_caracteristico, si).
prop(vegetal, tienen_forma_de_arbol, no).
prop(vegetal, tienen_partes_blancas, si).
prop(vegetal, contienen_vitamina_b12, no).
prop(vegetal, contienen_vitamina_c, si).
prop(vegetal, contienen_vitamina_k, si).

% ===========================================
% PROPIEDADES ESPECIFICAS DE INSTANCIAS
% Override de propiedades heredadas
% ===========================================

prop(queso, facil_digestion, si).              % Override: lacteo tiene no
prop(mango, son_verdes, no).                   % Override especifico para mango
prop(papa, tiene_agua, si).                    % Override: legumbre tiene no
prop(yogurt, es_procesado, si).                % Nueva propiedad especifica
prop(aceite_de_oliva, son_grasas_saludables, si). % Refuerza propiedad de grasa
prop(pescado, tiene_omega3, si).               % Nueva propiedad especifica
prop(leche, tiene_calcio, si).                 % Nueva propiedad especifica

% Regla 1: Propiedad definida directamente en la entidad (maxima prioridad)
property(Entidad,Prop,Valor) :- prop(Entidad,Prop,Valor).

% Regla 2: Herencia de instancia a clase
property(Entidad,Prop,Valor) :- 
    inst(Entidad,Clase),property(Clase,Prop,Valor).

% Regla 3: Herencia de clase a superclase
property(Entidad,Prop,Valor) :- 
    es_un(Entidad,Superior),property(Superior,Prop,Valor).

% Obtener todas las propiedades de una entidad
todas_propiedades(Entidad, ListaPropiedades) :-
    findall([Prop, Valor], property(Entidad, Prop, Valor), ListaPropiedades).

% Verificar si una entidad es de un tipo especifico
es_tipo(Instancia, Tipo) :-
    inst(Instancia, Tipo).
es_tipo(Instancia, Tipo) :-
    inst(Instancia, ClaseDirecta),
    es_un(ClaseDirecta, Tipo).

% Obtener todas las instancias de una categoria
instancias_de(Categoria, Instancias) :-
    findall(Inst, inst(Inst, Categoria), Instancias).

% Buscar alimentos con una propiedad especifica
alimentos_con_propiedad(Propiedad, Valor, Alimentos) :-
    findall(Alimento, 
            (inst(Alimento, _), property(Alimento, Propiedad, Valor)), 
            Alimentos).

% Comparar propiedades de dos alimentos
comparar_alimentos(Alimento1, Alimento2) :-
    write('Propiedades de '), write(Alimento1), write(':'), nl,
    todas_propiedades(Alimento1, Props1),
    mostrar_propiedades(Props1), nl,
    write('Propiedades de '), write(Alimento2), write(':'), nl,
    todas_propiedades(Alimento2, Props2),
    mostrar_propiedades(Props2).

% Auxiliar para mostrar propiedades
mostrar_propiedades([]).
mostrar_propiedades([[Prop, Valor]|Resto]) :-
    write('  - '), write(Prop), write(': '), write(Valor), nl,
    mostrar_propiedades(Resto).

% Encontrar propiedades compartidas entre categorias
propiedades_compartidas(Categoria1, Categoria2, PropiedadesComunes) :-
    findall([Prop, Valor], 
            (property(Categoria1, Prop, Valor), 
             property(Categoria2, Prop, Valor)), 
            PropiedadesComunes).

% Verificar herencia de una propiedad especifica
traza_herencia(Entidad, Propiedad, Valor) :-
    prop(Entidad, Propiedad, Valor),
    write('Propiedad definida directamente en '), write(Entidad), nl, !.
traza_herencia(Entidad, Propiedad, Valor) :-
    inst(Entidad, Clase),
    property(Clase, Propiedad, Valor),
    write('Propiedad heredada de la clase '), write(Clase), nl,
    traza_herencia(Clase, Propiedad, Valor).
traza_herencia(Entidad, Propiedad, Valor) :-
    es_un(Entidad, Superior),
    property(Superior, Propiedad, Valor),
    write('Propiedad heredada de la superclase '), write(Superior), nl,
    traza_herencia(Superior, Propiedad, Valor).

% ===========================================
% CONSULTAS DE EJEMPLO PARA PROBAR EL SISTEMA
% ===========================================

% ?- property(queso, tiene_proteina, X).
% ?- property(mango, son_verdes, X).
% ?- todas_propiedades(papa, Props).
% ?- es_tipo(queso, alimento).
% ?- instancias_de(carne, Carnes).
% ?- alimentos_con_propiedad(tiene_agua, si, Alimentos).
% ?- comparar_alimentos(queso, yogurt).
% ?- propiedades_compartidas(carne, lacteo, Comunes).
% ?- traza_herencia(queso, facil_digestion, si).
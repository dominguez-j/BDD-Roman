### [Link Relax](https://dbis-uibk.github.io/relax/calc/gist/552932a29392f8272951e01ada813ae1/imdbsample/0)

### Consigna
Resuelva en clase utilizando la base de datos de IMDB las siguientes consultas:

A. Mostrar los actores cuyo nombre sea Brad.
#
`σfirst_name = 'Brad'(actors)`
#
B. Mostrar el nombre y apellido de directores catalogados como de ’Sci-Fi’ (ciencia ficcion)
con una probabilidad mayor igual a 0.5.
#
`GENERO_DIRECTORES = πdirector_id(σprob ≥ 0.5 ∧ genre='Sci-Fi'directors_genres)`
`πfirst_name,last_name(directors ⨝id=director_id GENERO_DIRECTORES)`
#
C. Mostrar los nombres de las películas filmadas por James(I) Cameron que figuren en la
base.
#
`JAMES = πid(σfirst_name = 'James (I)' ∧ last_name = 'Cameron' (directors))`
`PELICULA_JAMES = πmovie_id(JAMES ⨝id=director_id movies_directors)`
`πname(PELICULA_JAMES ⨝movie_id=id movies)`
#
D. Mostrar los nombres y apellidos de las actrices que trabajaron en la película ’Judgment
at Nuremberg’
#
`PELICULA_ID = πid(σname='Judgment at Nuremberg' (movies))`
`ACTOR_ID = πactor_id(PELICULA_ID ⨝id=movie_id roles)`
`πfirst_name,last_name(σgender='F'(actors ⨝actors.id=actor_id ACTOR_ID))`
#
E. Muestre los actores que trabajaron en todas las películas de Woody Allen de la base.
Cuantas películas de este director hay en la base?
#
`WOODY_ID = πid(σfirst_name='Woody' ∧ last_name='Allen' directors)`
`MOVIES_IDS = πmovie_id(WOODY_ID ⨝id=director_id movies_directors)`
`ACTORES_IDS = πactor_id,movie_id(roles)`
`ACTORES_WOODY = ACTORES_IDS ÷ MOVIES_IDS`
`πfirst_name,last_name,id(ACTORES_WOODY ⨝actor_id=id actors)`
#
F. Directores que abarcaron, al menos, los mismos géneros que Welles (géneros en directores).
#
`WELLES_ID = πid(σlast_name = 'Welles'(directors))`
`NOMBRE_GENEROS = πdirectors_genres.genre(WELLES_ID ⨝ (directors.id = directors_genres.director_id) directors_genres)`
`DIRECTORES = πdirector_id,genre(directors_genres)`
`DIRECTORES_IDS = DIRECTORES ÷ NOMBRE_GENEROS`
`πfirst_name,last_name(DIRECTORES_IDS ⨝ (directors_genres.director_id = directors.id) directors)`
#
G. Actores que filmaron más de una película en algún año a partir de 1999
#
`MOVIES_AFTER_1999_IDS = πid(σ(year ≥ 1999)(movies))`
`ROLES_IN_MOVIES = πactor_id,movie_id (MOVIES_AFTER_1999_IDS ⨝id=movie_id roles)`
`ROLES_IN_MOVIES_2 = ρ roles_2 (ROLES_IN_MOVIES)`
`ACTOR_MORE_THAN_ONE_MOVIE = π roles.actor_id (ROLES_IN_MOVIES ⨝ roles.actor_id = roles_2.actor_id ∧ roles.movie_id ≠ roles_2.movie_id ROLES_IN_MOVIES_2)`
`RESULT_ACTORS_NAMES = π first_name, last_name (actors ⨝ actors.id = roles.actor_id ACTOR_MORE_THAN_ONE_MOVIE)`
`RESULT_ACTORS_NAMES`
#
H. Listar las películas del último año.
#
`M1 = ρ M1(movies)`
`M2 = ρ M2(movies)`
`T = σ M1.year < M2.year (M1⨯M2)`
`P = πM1.name (T)`
`πname(movies) - P`
#
I. Películas del director Spielberg en las que actuó Harrison (I) Ford.
#
`spielberg = πid(σlast_name = 'Spielberg'(directors))` 
`harrison_ford = πid(σ first_name = 'Harrison (I)' ∧ last_name = 'Ford'(actors))`
`spielberg_movies = πmovie_id(movies_directors ⨝ movies_directors.director_id = directors.id spielberg)`
`spielberg_roles = π actor_id, movie_id (roles ⨝ spielberg_movies)`
`spielberg_ford_movies = πmovie_id (spielberg_roles ⨝ roles.actor_id = actors.id harrison_ford)`
`πname(movies ⨝ movies.id = roles.movie_id spielberg_ford_movies)`
#
J. Películas del director Spielberg en las que no actuó Harrison (I) Ford.
#
`spielberg = πid(σlast_name = 'Spielberg'(directors))` 
`harrison_ford = πid(σ first_name = 'Harrison (I)' ∧ last_name = 'Ford'(actors))`
`spielberg_movies = πmovie_id(movies_directors ⨝ movies_directors.director_id = directors.id spielberg)`
`spielberg_roles = π actor_id, movie_id (roles ⨝ spielberg_movies)`
`spielberg_ford_movies = πmovie_id (spielberg_roles ⨝ roles.actor_id = actors.id harrison_ford)`
`spielberg_no_ford_movies = spielberg_movies - spielberg_ford_movies`
`πname(movies ⨝ movies.id = movies_directors.movie_id spielberg_no_ford_movies)`
#
K. Películas en las que actuó Harrison (I) Ford que no dirigió Spielberg.
#
`spielberg = πid(σlast_name = 'Spielberg'(directors))` 
`harrison_ford = πid(σ first_name = 'Harrison (I)' ∧ last_name = 'Ford'(actors))` 
`spielberg_movies = πmovie_id(movies_directors ⨝ movies_directors.director_id = directors.id spielberg)`
`ford_movies = πmovie_id(roles ⨝ roles.actor_id = actors.id harrison_ford)`
`πname(movies ⨝ movies.id = roles.movie_id (ford_movies - spielberg_movies))`
#
L. Directores que filmaron películas de más de tres géneros distintos, uno de los cuales sea
’Film-Noir’
#
`M1 = ρ M1(directors_genres)`
`M2 = ρ M2(directors_genres)`
`M3 = ρ M3(σgenre='Film-Noir'(directors_genres))`
`M = σ(M1.director_id = M2.director_id ∧ M1.genre≠M2.genre) (M1⨯M2)`
`J = σ(M3.director_id = M1.director_id ∧ M3.genre≠M2.genre ∧ M3.genre≠M1.genre) (M3⨯M)`
`IDS_DIRECTORES = πM3.director_id(J)`
`πfirst_name,last_name(IDS_DIRECTORES⨝(M3.director_id = directors.id) directors)`
#
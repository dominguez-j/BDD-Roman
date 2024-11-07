## Consultas básicas

1.  Hallar los tweets del usuario con userid ‘818839458’.
~~~
query: {"user.id_str": "818839458"} 
~~~
2.  Hallar aquellos tweets que tengan más de 500000 retweets.
~~~
query: {retweet_count: {$gt: 500000}}
~~~
3.  Mostrar la cantidad de retweets de los tweets que se hayan hecho desde Argentina o Brasil.
~~~
query:  {$or: [
		{country: "Argentina"}, 
		{country: "Brasil"}]} 
project: {retweet_count: 1}
~~~
4.  Hallar los usuarios que tengan tweets con 200000 o más retweets y sean en idioma español.

~~~
query:  {$and: [
		{retweet_count: {$gte: 200000}}, 
		{lang: "es"}]} 
~~~
5.  Mostrar la cantidad de retweets para los tweets que no se hayan hecho en Argentina ni
Brasil, pero sí tengan un lugar definido y sean en español.
~~~
query:  {$and: [{country: {$nin:["Argentina", "Brasil"]}},
	    {country: {$exists: true}},
	    {lang: "es"}]
} 
project: {retweet_count: 1}`
~~~
6.  Mostrar los screen name de aquellos usuarios que tengan “Juan” como parte de su nombre.

~~~
query: {"user.name": /Juan/}
project: {"user.screen_name": 1}
~~~
7.  Mostrar de los 10 tweets con más retweets, su usuario y la cantidad de retweets.
~~~ 
project: {"user.name": 1, retweet_count: 1}
sort: {retweet_count: -1}
limit: 10 
~~~

## Consultas de Agregación

1. Mostrar de los 10 tweets con más retweets, su usuario y la cantidad de retweets. Ordenar
la salida de forma ascendente.
~~~
[
  {
    $project:
      {
        user: 1,
        retweet_count: 1
      }
  },	
  {
    $sort: {
      retweet_count: -1
    }
  },
  {
    $limit:
      10
  },
  {
    $sort: {
      retweet_count: 1
    }
  }
]
~~~
2. Encontrar los 10 hashtags más usados.
~~~
[
  {
    $unwind: "$hashtags"
  },
  {
    $group: {
      _id: "$hashtags.text",
      cantidad: {
        $count: {}
      }
    }
  },
  {
    $sort: {
      cantidad: -1
    }
  },
  {
    $limit: 10
  }
]
~~~
3. Encontrar a los 5 usuarios más mencionados. (les hicieron @)
~~~
[
  {
    $unwind: "$user_mentions"
  },
  {
    $group: {
      _id: "$user_mentions.id",
	  nombre: "$user_mentions.name"
      cantidad: {
        $count: {}
      }
    }
  },
  {
    $sort: {
      cantidad: -1
    }
  },
  {
    $limit: 5
  }
]
~~~
4. Hallar la cantidad de retweets promedio para los tweets que se hayan hecho desde Argentina
y aquellos que no.
~~~
[
  {
    $group: {
      _id: {
        $cond: {
          if: {
            $eq: ["$country", "Argentina"]
          },
          then: "Argentina",
          else: "Otros"
        }
      },
      retweets_promedios: {
        $avg: "$retweet_count"
      }
    }
  }
]
~~~
5. Por cada usuario obtener una lista de ids de tweets y el largo de la misma.
~~~
[
  {
	$group: {
 	 	_id: "$user.id_str",
		tweets: {$addToSet: "$_id"},
  		cantidad: {$count: {}}
	}
  }
]
~~~
6. Hallar la máxima cantidad de retweets totales que tuvo algún usuario.
~~~
[
  {
    $group:
      {
        _id: "$user.id_str",
        max_ret:
        {
          $max: "$retweet_count"
        }
      }
  },
  {
    $sort:
      {
        max_ret: -1
      }
  },
  {
    $limit: 1
  }
]
~~~
7. Hallar para cada intervalo de una hora cuántos tweets realizó cada usuario.
~~~

~~~
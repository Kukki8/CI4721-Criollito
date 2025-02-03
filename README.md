# Criollito
Criollito es un lenguaje de programación inspirado en lenguajes como C o Java, pero con un toque criollo venezolano. La idea es que sea un lenguaje de programación sencillo, divertido y fácil de entender para cualquier persona que hable español.

## Tipos Primitivos

- Caracteres (beta): ASCII.
- Booleanos (calidad): `chevere` y `chimbo`
- Enteros (lucas): Números, pueden ser positivos o negativos.
- Flotantes (sencillo): Números con decimales. Se reconocen por el punto antes de los decimales.

## Tipos Compuestos

- Arreglos (bululu): 
    - `tipo nombre[tamaño]`. Por ejemplo: `lucas arreglo[3] = [1, 2, 3]`
- String (labia): 
    - `“Lorem ipsum”`. Por ejemplo: `labia nombre[10] = “Hola mundo”`
- Registros (saime): 
    - `saime nombre { tipo valor; }`. 
    - Por ejemplo: `saime persona { labia nombre[20]; lucas edad; }`
    - Acceso al valor de un campo: `persona👉nombre`
- Variantes (pastelero): 
    - `pastelero nombre { lucas: lucas }`
- Apuntador, referenciación (guachiman): 
    - `👉a`
- Desreferenciación: 
    - `👈a`

## Operadores

- Booleanos: `&&`, `||`, `!`, `separeceigualito`, `nosepareceigualito`, `mayolke`, `menolke`, `mayolke?`, `menolke?`
- Aritméticos: `+`, `-`, `*`, `/`, `%`
- Asignación: `=`

## Palabras reservadas

### Variables

`<tipo> nombre = <valor>`

Los nombres de las variables no pueden comenzar con los siguientes caracteres:

- Números: `01234567890`
- Signos ortográficos: `¿,?,¡,!,{},[],(),\,|,@,#,_,etc`

### Mecanismos de selección
If: `porsia`, else: `conchale`
```
Ej.
porsia (a separeceigualito b) {
	cuerpo
} conchale porsia (b separeceigualito c) {
	cuerpo
} conchale {
    cuerpo
}
```

### Mecanismos de repetición

#### Determinado:
For: `para a en bululú {}`
```
para a en bululú {}

para a de lucas a lucas {}

Ej:
lucas a[3] = [1, 2, 3];
para x en a {
    digalo(x);
}
para x de 0 a 5 {
    digalo(x);
}
```

#### Indeterminado:
While: `mientras (condición) echale pichón {}`
```
mientras (condicion) echale pichon {}

Ej:
mientras (x menolke 3) echale pichon { paralo }
```
#### Control en los mecanismos de repetición
- Break: `paralo`
- Continue: `palante`

### Subrutinas
Las subrutinas son de primer orden. Tienen pasaje de parámetros por valor y por referencia. El pasaje de parámetros por defecto es por valor. En caso de querer pasar por referencia, se debe indicar con el símbolo `👉` al final del tipo de dato.
```
tipo chamba (tipo a) {
	cuerpo
	fuimonos a;
}

Ej. pasaje de parámetros por valor (por defecto):
lucas chamba (lucas a) {
	a = a + 1;
	fuimonos a;
}

Ej. pasaje de parámetros por referencia:

saime gente {
	lucas bolivitas;
}

lucas chamba valorDelBono(gente👉 persona) {
	fuimonos persona.bolivitas;
}
```
**Return: `fuimonos`**

# Otros
Algunas cosas generales definidas dentro del lenguaje:
- Secuenciación: `;`
- Par ordenado (Cuadre): `cuadre (<tipo>, <tipo>) nombre`
- Error: `guacala("Mensaje de error")`
- Print: `digalo("Mensaje")`
- Input: `rotalo(tamaño)`
- Comentarios (solo en línea): `💬 Lorem ipsum.`
- Main (como en C): `vacio chisme() { fuimonos; }`

# Programas en Criollito

## Hola mundo
```
vacio chisme() {
	digalo("Hola mundo");
	fuimonos;
}
```

## Hola usuario
```
vacio chisme() {
	digalo("Ingresa tu nombre");
	labia nombre[50] = rotalo(50);
	digalo(nombre);
	fuimonos;
}
```

## Sumar números
```
vacio chisme() {
	lucas res = 0;
	mientras (chevere) echale pichon {
		lucas numero = rotalo(50);
		porsia (numero separeceigualito 0) {
			paralo;
		} conchale {
			res = res + numero;
		}
	}
	digalo(res);
	fuimonos;
}
```

## Fibonacci
```
lucas chamba nthFibonacci(lucas n) {
	porsia (n menolke? 1) {
		fuimonos n;
	}
	fuimonos nthFibonacci(n-1) + nthFibonacci(n-2);
}
vacio chisme() {
	lucas n = rotalo(50);
	lucas res = nthFibonacci(n);
	fuimonos res;
}
```

## Multiplicación de matrices
```
lucas[][] mulMat(lucas👉 a[][], lucas👉 b[][]) {
	lucas r1 = a.sais();
	lucas c1 = a[0].sais();
	lucas r2 = b.sais();
	lucas c2 = b[0].sais();
	
	porsia (c1 nosepareceigualito r2) {
		digalo("Invalid input");
		fuimonos -1;
	}

	lucas res[r1][c2];
	lucas i = 0;
	lucas j = 0;
	lucas k = 0;

	mientras (i menolke r1) echale pichon {
		mientras (j menolke c2) echale pichon {
			res[i][j] = 0;
			
			mientras (k menolke c1) echale pichon {
				res[i][j] = res[i][j] + a[i][k] * b[k][j];
				k = k+1;
			}
			j = j+1;
		}
		i = i+1;
	}

	fuimonos res;
}

vacio chisme() {
	fuimonos;
}
```

## Algoritmo Kruskal
```
saime Grafito {
	Arista aristas[];
	lucas vertices;
}

saime Arista {
	lucas valor;
	lucas origen;
	lucas objetivo;
}

saime listaPrioridad{
	Arista elementos[];
}

listaPrioridad crearListPrioridad(Arista aristas[]) {

	listaPrioridad nuevaLista;
	nuevaLista.elementos[aristas.sais()];

	lucas i = 0;

	mientras( i menolke nuevaLista.elementos.sais() + 1 ) echale pichon {
		nuevaLista.elementos[i] = miLista.elementos[i];
		i = i + 1;
	}

	fuimonos nuevaLista;

}

listaPrioridad agregarAristaListaPrioridad(listaPrioridad miLista, Arista elemento) {

	nuevoTamano = miLista.elementos.sais() + 1;
	listaPrioridad nuevaLista;
	nuevaLista.elementos[nuevoTamano];
	lucas i = 0;

	mientras( i menolke nuevaLista.elementos.sais()) echale pichon {
		nuevaLista.elementos[i] = miLista.elementos[i];
		i = i + 1;
	}

	nuevaLista.elementos[nuevoTamano - 1] = elemento;
	fuimonos ordernarLista(nuevaLista);

}

listaPrioridad ordernarLista(listaPrioridad listaDesordenada) {
	
	lucas i = 0;
	lucas j = i + 1;
	lucas ronda = 0;

	mientras(ronda menolke listaDesordenada.elementos.sais() + 1) echale pichon {

		porsia (j separeceigualito listaDesordenada.elementos.sais()){
			ronda = ronda + 1;
			i = 0 ;
			j = 1;
			palante;
		}

		conchale porsia (listaDesordenada.elementos[i].valor mayolke listaDesordenada.elementos[j].valor ) {
			Arista aux = listaDesordenada.elementos[i];
			listaDesordenada.elementos[i] = listaDesordenada.elementos[j]
			listaDesordenada.elementos[j] = aux;
		}

		i = i + 1;
		j = j + 1;
	}

	fuimonos listaDesordenada;
}

Grafo Kruskal(Grafito👉 grafito) {
	
	lucas papa[n];
    lucas nivel[n];

	para i de 0 a n {

		papa[i] = -1;
		nivel[i] = 1;
	}

	// Crear lista de prioridades
	listaPrioridad aristasOrdenadas = crearListPrioridad(👈grafito.aristas);

	aristasOrdenadas = ordernarLista(aristasOrdenadas);

	lucas resultado = 0;
	lucas contadorAristas = 0;

	para arista en aristasOrdenadas {

		lucas w = arista.valor;
		lucas x = arista.origen;
		lucas y = arista.objetivo;

		// Verificar si hay un ciclo

		porsia (buscarRaiz(x,papa) nosepareceigualito buscarRaiz(y,papa)) {
			unir(x, y, papa, nivel);
			resultado = resultado +  w;

			contadorAristas = contadorAristas + 1;
		}

		// Verifica que no se pase del limite de las aristas
		porsia (contadorAristas separeceigualito 👈grafito.vertices - 1) {
			paralo;
		}
	}
	digalo(resultado);

}
  
// Funcion que busca la raiz de los sets creados durante el algoritmo
lucas buscarRaiz(lucas i, lucas👉 padres[])
{
	porsia(padres[i] separeceigualito -1)
		fuimonos i;

	padres[i] = buscarRaiz(padres[i],padres);
	fuimonos padres[i];
}

    
vacio unir(lucas x, lucas y, lucas👉 padres[], lucas👉 nivel[])
{
	lucas s1 = buscarRaiz(x,padres);
	lucas s2 = buscarRaiz(y,padres);

	porsia (s1 nosepareceigualito s2) {
		porsia (nivel[s1] menolke nivel[s2]) {
			padres[s1] = s2;
		}
		conchale porsia (nivel[s1] mayolke nivel[s2]) {
			padres[s2] = s1;
		}
		conchale {
			padres[s2] = s1;
			nivel[s1] = nivel[s1] + 1;
		}
	}
}

```

## Intérprete del lenguaje Brainf*ck

```
vacio chisme() {
    digalo("Ingresa el código de Brainf*ck: ");
    labia codigo[30000] = rotalo(30000);
    lucas cinta[30000];
    lucas puntero = 0;
    lucas i = 0;

    mientras (i menolke codigo.sais()) echale pichon {
        porsia (codigo[i] separeceigualito '>') {
            puntero = puntero + 1;
        } conchale porsia (codigo[i] separeceigualito '<' && puntero mayolke 0) {
            puntero = puntero - 1;
        } conchale porsia (codigo[i] separeceigualito '+') {
            cinta[puntero] = cinta[puntero] + 1;
        } conchale porsia (codigo[i] separeceigualito '-') {
            cinta[puntero] = cinta[puntero] - 1;
        } conchale porsia (codigo[i] separeceigualito '.') {
            digalo(cinta[puntero]);
        } conchale porsia (codigo[i] separeceigualito ',') {
            cinta[puntero] = rotalo(1);
        } conchale porsia (codigo[i] separeceigualito '[') {
            porsia (cinta[puntero] separeceigualito 0) {
                lucas contador = 1;
                mientras (contador mayolke 0) echale pichon {
                    i = i + 1;
                    porsia (codigo[i] separeceigualito '[') {
                        contador = contador + 1;
                    } conchale porsia (codigo[i] separeceigualito ']') {
                        contador = contador - 1;
                    }
                }
            }
        } conchale porsia (codigo[i] separeceigualito ']') {
            porsia (cinta[puntero] nosepareceigualito 0) {
                lucas contador = 1;
                mientras (contador mayolke 0) echale pichon {
                    i = i - 1;
                    porsia (codigo[i] separeceigualito '[') {
                        contador = contador - 1;
                    } conchale porsia (codigo[i] separeceigualito ']') {
                        contador = contador + 1;
                    }
                }
            }
        } conchale {
            guacala("No se reconoce el caracter");
        }
        i = i + 1;
    }
    fuimonos;
}
```

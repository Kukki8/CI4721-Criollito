# Criollito
Criollito es un lenguaje de programación inspirado en lenguajes como C o Java, pero con un toque criollo venezolano. La idea es que sea un lenguaje de programación sencillo, divertido y fácil de entender para cualquier persona que hable español.

## Tipos Primitivos

- Caracteres (Beta): Alfanuméricos.
- Booleanos (Calidad): `chévere` y `chimbo`
- Enteros (Lucas): Números, pueden ser positivos o negativos.
- Flotantes (Sencillo): Números con decimales.

## Tipos Compuestos

- Arreglos (Bululú): [ a, s, d, f ], `tipo nombre[tamaño], lucas nombre[] = [1, 2, 3]`
- String (Labia): “asfda”
- Registros (Saime): `saime nombre { tipo valor }`
- Variantes (Pastelero): `pastelero nombre { lucas: lucas }`
- Apuntador (Guachimán): `👉a`

## Operadores

- Booleanos: `&&`, `||`, `!`, `separeceigualito`, `nosepareceigualito`, `mayolke`, `menolke`, `mayolke?`, `menolke?`
- Aritméticos: `+`, `-`, `*`, `/`, `%`
- Asignación: `=`

## Palabras reservadas

### Mecanismos de selección
If: porsia, else: cónchale
```
Ej.
porsia (asdfa = asdf) {
	cuerpo
} conchale porsia (asdfa = asdf) {
	cuerpo
} conchale {
    cuerpo
}
```

### Mecanismos de repetición

#### Determinado:
For: 
```
para a en bululú {}

para a de lucas a lucas {}

Ej:
lucas a[3] = [1, 2, 3];
para x en a {}
para x de 0 a 5 {}
```

#### Indeterminado:
While:
```
mientras (condicion) echale pichon {}

Ej:
mientras (x < 3) echale pichon {paralo}
```
#### Control en los mecanismos de repetición
- Break: Paralo
- Continue: Palante

### Subrutinas
Las subrutinas son de primer orden. Tienen pasaje de parámetros por valor y por referencia. El pasaje de parámetros por defecto es por valor. En caso de querer pasar por referencia, se debe indicar con el símbolo `👉` al final del tipo de dato.
```
tipo chamba (tipo a) {
	cuerpo
	fuimonos vaina<tipo>;
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
- Par ordenado (Cuadre): `(a, b)`
- Error: Guacala
- Print: Digalo
- Input: Rotalo
- Main (como en C): `vacio chisme() { fuimonos; }`

# Programas

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
	labia nombre = rotalo();
	digalo(nombre);
	fuimonos;
}
```

## Sumar números
```
vacio chisme() {
	lucas res = 0;
	mientras (chevere) echale pichon {
		lucas numero = rotalo();
		porsia (numero == 0) {
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
	porsia (n <= 1) {
		fuimonos n;
	}
	fuimonos nthFibonacci(n-1) + nthFibonacci(n-2);
}
vacio chisme() {
	lucas n = rotalo();
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
	
	porsia (c1 != r2) {
		digalo("Invalid input");
		fuimonos -1;
	}

	lucas res[r1][c2];
	lucas i = 0;
	lucas j = 0;
	lucas k = 0;

	mientras (i < r1) echale pichon {
		mientras (j < c2) echale pichon {
			res[i][j] = 0;
			
			mientras (k < c1) echale pichon {
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
**TODO**
```
```

## Intérprete del lenguaje Brainf*ck

```
vacio chisme() {
    digalo("Ingresa el código de Brainf*ck: ");
    labia codigo = rotalo();
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
            cinta[puntero] = rotalo();
        } conchale porsia (codigo[i] separeceigualito '[') {
            porsia (cinta[puntero] separeceigualito 0) {
                lucas contador = 1;
                mientras (contador > 0) echale pichon {
                    i = i + 1;
                    porsia (codigo[i] separeceigualito '[') {
                        contador = contador + 1;
                    } conchale porsia (codigo[i] separeceigualito ']') {
                        contador = contador - 1;
                    }
                }
            }
        } conchale porsia (codigo[i] separeceigualito ']') {
            porsia (cinta[puntero] != 0) {
                lucas contador = 1;
                mientras (contador > 0) echale pichon {
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

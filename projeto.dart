import 'package:flutter/material.dart';
import 'dart:math'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Jogo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, 
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int tesouroNumero;
  late int bombaNumero; 
  late int monstroNumero;
  String mensagem = "Encontre o tesouro! Cuidado com a bomba e o monstro.";

  List<bool> botoesAtivos = List.generate(20, (_) => true);

  List<String> conteudoBotoes = List.generate(20, (index) => "${index + 1}");
  
  @override
  void initState() {
    super.initState();
    iniciarNovoJogo();
  }

  void iniciarNovoJogo() {
    final random = Random();
    final numeros = <int>{};

    // Logica para gerar os 3 numeros para o tesouro, monstro e bomba
    while (numeros.length < 3) {
      numeros.add(random.nextInt(20) + 1);
    }

    final listaNumeros = numeros.toList();
    tesouroNumero = listaNumeros[0];
    bombaNumero = listaNumeros[1];
    monstroNumero = listaNumeros[2];

    setState(() {
      mensagem = "Encontre o tesouro! Cuidado com a bomba e o monstro.";
      botoesAtivos = List.generate(20, (_) => true);
      conteudoBotoes = List.generate(20, (index) => "${index + 1}");
    });
    
    // Debug para localizar os itens e mostrar na apresentação
    print("Tesouro: $tesouroNumero, Bomba: $bombaNumero, Monstro: $monstroNumero");
  }

  void aoClicarBotao(int numero) {
    setState(() {
      if (numero == tesouroNumero) {
        conteudoBotoes[numero - 1] = "🏆";
        mensagem = "Parabéns! Você encontrou o tesouro!";
        desativarTodosBotoes();
      } else if (numero == bombaNumero) {
        conteudoBotoes[numero - 1] = "💣";
        mensagem = "BOOM! Você encontrou a bomba e perdeu!";
        revelarItensEspeciais();
        desativarTodosBotoes();
      } else if (numero == monstroNumero) {
        conteudoBotoes[numero - 1] = "👾";
        mensagem = "Oh não! Você encontrou o monstro e perdeu!";
        revelarItensEspeciais();
        desativarTodosBotoes();
      } else {
        if (tesouroNumero > numero) {
          conteudoBotoes[numero - 1] = "⬆️";
          mensagem = "O tesouro está em um número maior!";
        } else {
          conteudoBotoes[numero - 1] = "⬇️";
          mensagem = "O tesouro está em um número menor!";
        }
        botoesAtivos[numero - 1] = false;
      }
    });
  }
  
  void desativarTodosBotoes() {
    setState(() {
      botoesAtivos = List.generate(20, (_) => false);
    });
  }
  
  // Mostra a posição de cada item
  void revelarItensEspeciais() {
    setState(() {
      conteudoBotoes[tesouroNumero - 1] = "🏆";
      conteudoBotoes[bombaNumero - 1] = "💣";
      conteudoBotoes[monstroNumero - 1] = "👾";
    });
  }

  Color obterCorBotao(int index) {
    if (!botoesAtivos[index]) {
      return Colors.teal.shade200;
    }
    return Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Text(
                    'THE JOGO',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    mensagem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10, 
                    ),
                    itemCount: 20, 
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: botoesAtivos[index] 
                          ? () => aoClicarBotao(index + 1) 
                          : null, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: obterCorBotao(index),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            conteudoBotoes[index],
                            style: TextStyle(
                              fontSize: conteudoBotoes[index].length > 2 ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20), 
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: iniciarNovoJogo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'NOVO JOGO',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

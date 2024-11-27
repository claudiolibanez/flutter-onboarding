import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_onboarding/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController1; // Coluna 1 (para cima)
  late ScrollController _scrollController2; // Coluna 2 (para baixo)
  late ScrollController _scrollController3; // Coluna 3 (para cima)
  late ScrollController _scrollController4; // Coluna 4 (para baixo)
  late ScrollController _scrollController5; // Coluna 5 (para cima)

  // Lista de imagens
  final List<String> imagePaths = [
    'assets/image7.jpeg',
    'assets/image8.jpeg',
    'assets/image9.jpeg',
    'assets/image10.jpeg',
    'assets/image11.jpeg',
    'assets/image12.jpeg',
    // Adicione mais imagens conforme necessário
  ];

  // Listas embaralhadas para cada coluna
  late List<String> shuffledImages1;
  late List<String> shuffledImages2;
  late List<String> shuffledImages3;
  late List<String> shuffledImages4;
  late List<String> shuffledImages5;

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores de rolagem
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController3 = ScrollController();
    _scrollController4 = ScrollController();
    _scrollController5 = ScrollController();

    // Embaralha a lista de imagens para cada coluna individualmente
    shuffledImages1 = List.from(imagePaths)..shuffle(Random());
    shuffledImages2 = List.from(imagePaths)..shuffle(Random());
    shuffledImages3 = List.from(imagePaths)..shuffle(Random());
    shuffledImages4 = List.from(imagePaths)..shuffle(Random());
    shuffledImages5 = List.from(imagePaths)..shuffle(Random());

    // Inicia a rolagem contínua para cada coluna
    _startAutoScroll(_scrollController1, true); // Coluna 1 - Para cima
    _startAutoScroll(_scrollController2, false); // Coluna 2 - Para baixo
    _startAutoScroll(_scrollController3, true); // Coluna 3 - Para cima
    _startAutoScroll(_scrollController4, false); // Coluna 4 - Para baixo
    _startAutoScroll(_scrollController5, true); // Coluna 5 - Para cima
  }

  void _startAutoScroll(ScrollController scrollController, bool scrollingUp) {
    Future.delayed(Duration(milliseconds: 70), () {
      if (scrollController.hasClients) {
        final position = scrollController.position;

        if (scrollingUp) {
          // Se rolando para cima
          if (position.pixels <= position.minScrollExtent) {
            // Se chegar ao topo, reseta a posição
            scrollController.jumpTo(position.maxScrollExtent);
          } else {
            scrollController.jumpTo(position.pixels - 1); // Move para cima
          }
        } else {
          // Se rolando para baixo
          if (position.pixels >= position.maxScrollExtent) {
            // Se chegar ao fundo, reseta a posição
            scrollController.jumpTo(position.minScrollExtent);
          } else {
            scrollController.jumpTo(position.pixels + 1); // Move para baixo
          }
        }
      }
      _startAutoScroll(scrollController, scrollingUp); // Chama novamente
    });
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
    _scrollController4.dispose();
    _scrollController5.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo escuro
      body: Stack(
        children: [
          // Colunas de imagens animadas
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(14.0, 0.0),
              child: Transform.scale(
                scale: 2.0, // Efeito de zoom para preencher a tela
                child: Transform.rotate(
                  angle: 355 * 3.14159265359 / 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImageColumn(_scrollController1, shuffledImages1),
                      const SizedBox(width: 5.0),
                      _buildImageColumn(_scrollController2, shuffledImages2),
                      const SizedBox(width: 5.0),
                      _buildImageColumn(_scrollController3, shuffledImages3),
                      const SizedBox(width: 5.0),
                      _buildImageColumn(_scrollController4, shuffledImages4),
                      const SizedBox(width: 5.0),
                      _buildImageColumn(_scrollController5, shuffledImages5),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Gradiente e Blur
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                // Gradiente branco suave
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.9),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bem-vindo ao nosso App!\nDescubra funcionalidades incríveis e personalize sua experiência.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _nextPage,
                        child: Text(
                          "Vamos Começar",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0, // Sem sombra
                          // Background builder
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          shadowColor: Colors.transparent,
                          side: BorderSide(
                              color: Colors.orange, width: 2), // Borda
                          backgroundBuilder: (context, size, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: child,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para construir a imagem com proporção de aspecto 2:3
  Widget _buildAspectImage(String assetPath) {
    return AspectRatio(
      aspectRatio: 2 / 3, // Proporção 2:3
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 4), // Sombra da imagem
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildImageColumn(
      ScrollController controller, List<String> shuffledImages) {
    return Expanded(
      child: ListView.builder(
        controller: controller,
        itemCount: 1000, // Para simular infinitude
        itemBuilder: (context, index) {
          // Usar a lista embaralhada da coluna
          final imageIndex =
              index % shuffledImages.length; // Usar a lista embaralhada
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: _buildAspectImage(shuffledImages[
                imageIndex]), // Usando a imagem da lista embaralhada
          );
        },
      ),
    );
  }
}

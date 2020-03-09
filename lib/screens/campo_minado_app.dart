import 'package:campo_minado/models/explosaso_exception.dart';
import 'package:flutter/material.dart';
import '../models/tabuleiro.dart';
import '../models/campo.dart';
import '../components/resultado_widget.dart';
import '../components/tabuleiro_widget.dart';

class CampoMinadoApp extends StatefulWidget {
  @override
  _CampoMinadoAppState createState() => _CampoMinadoAppState();
}

class _CampoMinadoAppState extends State<CampoMinadoApp> {
  bool _venceu;
  Tabuleiro _tabuleiro;

  void _reiniciar() {
    setState(() {
      _venceu = null;
      _tabuleiro.reiniciar();
    });
  }

  void _abrir(Campo campo) {
    if(_venceu != null) {
      return;
    }
    setState(() {
      try {
        campo.abrir();
        if(_tabuleiro.resolvido) {
          _venceu = true;
        }
      } on ExplosaoException {
        _venceu = false;
        _tabuleiro.revelarBombas();
      }
    });
  }

  void _alternarMarcacao(Campo campo) {
    if(_venceu != null) {
      return;
    }

    setState(() {
      campo.alternarMarcacao();
      if(_tabuleiro.resolvido) {
          _venceu = true;
        }
    });
  }

  Tabuleiro _getTabuleiro(double largura, double altura) {
    if(_tabuleiro == null) {
      int qtdColunas = 15;
      double tamanhoCampo = largura /qtdColunas;
      int qtdLinhas = (altura / tamanhoCampo).floor();
      _tabuleiro = Tabuleiro(
        colunas: qtdColunas,
        linhas: qtdLinhas,
        qtdBombas: 30,
      );
    }
    return _tabuleiro;
  }

  @override
  Widget build(BuildContext context) {
    // Campo vizinho1 = Campo(linha: 1, coluna: 0);
    // vizinho1.minar();
    // Campo vizinho2 = Campo(linha: 1, coluna: 1);
    // vizinho2.minar();

    // Campo campo = Campo(linha: 0, coluna: 0);
    // campo.adicioarVizinho(vizinho1);
    // campo.adicioarVizinho(vizinho2);
    // try {
    //   // campo.minar();
    //   campo.alternarMarcacao();
    // }on ExplosaoException {

    // }

    return MaterialApp(
      home: Scaffold(
        appBar: ResultadoWidget(venceu: _venceu, onReiniciar: _reiniciar,),
        body: Container(
          color: Colors.grey,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return TabuleiroWidget(
                tabuleiro: _getTabuleiro(
                  constraints.maxWidth, constraints.maxHeight),
                onAbrir: _abrir,
                onAlternarMarcacao: _alternarMarcacao,
              );
            }
          ),
        ),
      ),
    );
  }
}
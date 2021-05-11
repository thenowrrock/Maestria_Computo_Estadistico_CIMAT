#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 28 22:10:50 2020

@author: victor
"""
# ejecutar estas lineas si no esta instalado
# pip install spacy
# python -m spacy download es_core_news_sm
# python -m spacy download es_core_news_sm


# en colab
# !pip install spacy
# !python -m spacy download es_core_news_sm
# !python -m spacy download es_core_news_sm

### Librerias
import os
import re
import nltk

nltk.download('punkt')
from nltk.tokenize import word_tokenize
import string
from nltk.stem.snowball import SnowballStemmer

englishStemm = SnowballStemmer("english").stem
spanishStemm = SnowballStemmer("spanish").stem
import spacy

sp_es = spacy.load('es_core_news_sm')
sp_en = spacy.load('en_core_web_sm')

# import pattern
# from pattern.es import lemma as spanishlemma
# from pattern.en import lemma as englishlemma

nltk.download('stopwords')
from nltk.corpus import stopwords

stopEnglish = set(stopwords.words('english'))
stopSpanish = set(stopwords.words('spanish'))


# stopSpanish

def sorted_alphanumeric(data):
    convert = lambda text: int(text) if text.isdigit() else text.lower()
    alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
    return sorted(data, key=alphanum_key)


def listdir_fullpath(d):
    return [os.path.join(d, f) for f in sorted_alphanumeric(os.listdir(d))]


class preprocesaTexto():
    def __init__(self, idioma, _tokeniza=False, _aMinusculas=True,
                 _aMayusculas=False, _removerPuntuacion=True, _removerCaracteresRaros=True,
                 _quitarNumeros=True, _lematiza=False, _stemming=False, _quitarAcentos=False,
                 _remueveStop=False, _muestraCambios=False):
      """ Clase elaborada por Angel Domínguez Lozano (angel.dominguez@cimat.mx), para la clase NLP
          en CIMAT Monterrey.
          Modificada por Victor M (agregar spacy para lematización).
        La clase toma como parametro obligatorio el idioma a utilizar, con solo dos opciones
         'es' para español y 'en' para ingles.

        Se tienen las siguientes caracteristicas para preprocesar texto
          tokeniza: Devuelve una lista con el texto divido en tokens
          aMinusculas: Convierte cada letra mayuscula a minuscula
          aMayusculas: Convierte cada letra minuscula a mayuscula
          removerPuntuacion: Remueve los signos de puntuacion
          quitarNumeros: Remueve los numeros del texto
          lematiza: Regresa el texto con cada palabra lematizada
          stemming: Regresa el texto realizando stemming a cada palabra
          quitarAcentos: En el idioma español, sustituye letras con acentos por su correspondiente sin acento
          remueveStop: Remueve las stop words segun el idioma en cuestion
        Cada una de las funciones anteriores cuenta con su correpondiente parametro binario
          _tokeniza,_aMinusculas,_aMayusculas,_removerPuntuacion,_quitarNumeros
          _lematiza,_stemming,_quitarAcentos,_remueveStop
        que tienen la funcion de servir como auxiliaron para la funcion principal
          preprocesa, funcion que realiza sobre un texto dado todos los preprocesos con
          variable auxiliar activa. En caso de que _muestraCambios este activo,
          ademas se imprimira la transformacion del texto despues de cada paso.

        El default de las variables auxiliares es no tokenizar, convertir a minusculas
        , remover puntuacion, remover caracteres raros, quitar numeros, no lematizar,
        no hacer stemming, no quitar acentos, no quitar stop words y no mostrar los cambios.
    """
      self._tokeniza = _tokeniza
      self._aMinusculas = _aMinusculas
      self._aMayusculas = _aMayusculas
      self._removerPuntuacion = _removerPuntuacion
      self._removerCaracteresRaros = _removerCaracteresRaros
      self._quitarNumeros = _quitarNumeros
      self._lematiza = _lematiza
      self._stemming = _stemming
      self._quitarAcentos = _quitarAcentos
      self._remueveStop = _remueveStop
      self._muestraCambios = _muestraCambios
      self.idioma = idioma

    def tokeniza(self, texto):
        return word_tokenize(texto)

    def aMinusculas(self, texto):
        if self.idioma == 'es':
            ans = ""
            for c in texto:
                if c == 'Á': c = 'á'
                if c == 'É': c = 'é'
                if c == 'Í': c = 'í'
                if c == 'Ó': c = 'ó'
                if c == 'Ú': c = 'ú'
                if c == 'Ñ': c = 'ñ'
                if c == 'Ü': c = 'ü'
                ans += c
            return ans.lower()
        else:
            return texto.lower()

    def aMayusculas(self, texto):
        if self.idioma == 'es':
            ans = ""
            for c in texto:
                if c == 'á': c = 'Á'
                if c == 'é': c = 'É'
                if c == 'í': c = 'Í'
                if c == 'ó': c = 'Ó'
                if c == 'ú': c = 'Ú'
                if c == 'ñ': c = 'Ñ'
                if c == 'ü': c = 'Ü'
                ans += c
            return ans.upper()
        else:
            return texto.upper()

    def quitarAcentos(self, texto):
        if self.idioma == 'es':
            ans = ""
            for c in texto:
                if c == 'á': c = 'a'
                if c == 'é': c = 'e'
                if c == 'í': c = 'i'
                if c == 'ó': c = 'o'
                if c == 'ú': c = 'u'
                if c == 'Á': c = 'A'
                if c == 'É': c = 'E'
                if c == 'Í': c = 'I'
                if c == 'Ó': c = 'O'
                if c == 'Ú': c = 'U'
                ans += c
            return ans
        else:
            return texto

    def removerPuntuacion(self, texto):
        puntuacion = string.punctuation
        if self.idioma == 'es':
            puntuacion += "¡¿"
        temp = ""
        for c in texto:
            if not c in puntuacion:
                temp += c
        return temp

    def removerCaracteresRaros(self, texto):
        buenos = string.printable
        if self.idioma == 'es':
            buenos += "¡¿áéíóúÁÉÍÓÚÑñÜü"
        temp = ""
        for c in texto:
            if c in buenos:
                temp += c
        return temp

    def quitarNumeros(self, texto):
        temp = ""
        for c in texto:
            if not c.isdigit():
                temp += c
        return temp

    def lematiza(self, texto):
        temp = []
        if self.idioma == 'es':
            doc = sp_es(texto)
            for token in doc:
                temp.append(token.lemma_)
                temp.append(" ")
        else:
            doc = sp_en(texto)
            for token in doc:
                temp.append(token.lemma_)
                temp.append(" ")
        return "".join(temp)

    def stemming(self, texto):
        palabras = word_tokenize(texto)
        temp = []
        if self.idioma == 'es':
            for pal in palabras:
                temp.append(spanishStemm(pal))
                temp.append(" ")
        else:
            for pal in palabras:
                temp.append(englishStemm(pal))
                temp.append(" ")
        return "".join(temp)

    def remueveStop(self, texto):
        palabras = word_tokenize(texto)
        temp = []
        if self.idioma == 'es':
            for pal in palabras:
                if pal not in stopSpanish:
                    temp.append(pal)
                    temp.append(" ")
        else:
            for pal in palabras:
                if pal not in stopEnglish:
                    temp.append(pal)
                    temp.append(" ")
        return "".join(temp)

    def preprocesa(self, texto):
        ans = texto
        if self._muestraCambios: print("Inicial:\n", ans)
        if self._removerCaracteresRaros:
            ans = self.removerCaracteresRaros(ans)
            if self._muestraCambios: print("Quitando caracteres raros:\n", ans)
        if self._removerPuntuacion:
            ans = self.removerPuntuacion(ans)
            if self._muestraCambios: print("Quitando signos de puntuacion:\n", ans)
        if self._quitarNumeros:
            ans = self.quitarNumeros(ans)
            if self._muestraCambios: print("Quitando numeros:\n", ans)
        if self._aMinusculas:
            ans = self.aMinusculas(ans)
            if self._muestraCambios: print("Convirtiendo a minusculas:\n", ans)
        if self._aMayusculas:
            ans = self.aMayusculas(ans)
            if self._muestraCambios: print("Convirtiendo a mayusculas:\n", ans)
        if self._remueveStop:
            ans = self.remueveStop(ans)
            if self._muestraCambios: print("Quitando stop words:\n", ans)
        if self._quitarAcentos:
            ans = self.quitarAcentos(ans)
            if self._muestraCambios: print("Quitando acentos:\n", ans)
        if self._lematiza:
            ans = self.lematiza(ans)
            if self._muestraCambios: print("Lematizando:\n", ans)
        if self._stemming:
            ans = self.stemming(ans)
            if self._muestraCambios: print("Stemming:\n", ans)
        if self._tokeniza:
            ans = self.tokeniza(ans)
            if self._muestraCambios: print("Tokenizando:\n", ans)
        if self._muestraCambios: print("Final:\n", ans)
        return ans

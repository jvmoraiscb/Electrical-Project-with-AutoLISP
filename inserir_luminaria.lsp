(defun c:inserir_luminaria_meio() ; defun define uma funcaoo
  (guarda_variaveis)

  (ins_pt)
  (verificar_layer "luminarias" "1")
  (proc_ins ins_lum) ; as funcoes criam variaveis globais
  
  (restaura_variaveis)
)

(defun guarda_variaveis()
  (setq osnap_mode (getvar "osmode"))
)

(defun restaura_variaveis()
  (setvar "osmode" osnap_mode)
)

(defun proc_ins(pt_cent)
  ;(setq diametro (getint "\nInsira o diametro "))
  ;(setq pt_cent (getpoint "\nClique no local desejado: " )) ; getint recebe um valor inteiro e getpoint recebe um ponto marcado pelo usuario
  (setq diametro 40) ; setq recebe uma variavel e um valor para ela
  (setq pt1 (polar pt_cent (/ pi 2)       (/ diametro 2) )) ; polar recebe um ponto inicial, um angulo e um tamanho e cria uma linha
  (setq pt2 (polar pt_cent 0              (/ diametro 2) ))
  (setq pt3 (polar pt_cent pi       	    (/ diametro 2) ))
  
  (setq pt_c (polar(polar pt_cent pi (/ diametro 4)) (/ pi 2) (/ diametro 4) ))
  (setq txt_c (getstring "\nInforme o circuito: "))

  (setq pt_s (polar(polar pt_cent 0 (/ diametro 4)) (/ pi 2) (/ diametro 4) ))
  (setq txt_s (getstring "\nInforme a secao: "))

  (setq pt_p (polar pt_cent (/ (* pi 3) 2) (/ diametro 4) ))
  (setq txt_p (getstring "\nInforme a potencia "))
  
  (setvar "osmode" 0)
  
  (command "._circle" pt_cent "d" diametro) ; command chama uma funcao do autoCAD
  (command "._line" pt_cent pt1 "")
  (command "._line" pt_cent pt2 "")
  (command "._line" pt_cent pt3 "")
  (command "style" "texto_luminaria" "simplex" (/ diametro 4) "1" "0" "no" "no" "no")
  (command "._text" "j" "mc" pt_c 0 txt_c "")
  (command "._text" "j" "mc" pt_s 0 txt_s "")
  (command "style" "texto_luminaria2" "simplex" (/ diametro 5) "1" "0" "no" "no" "no")
  (command "._text" "j" "mc" pt_p 0 txt_p "")
)

(defun ins_pt()
  (setq pt1_ins_lum (getpoint "\nClique em um dos vertices do comodo: " ))
  (setq pt2_ins_lum (getpoint "\nClique em outro vertice do comodo: " ))
  (setq ang_pt1_pt2_ins_lum (angle pt1_ins_lum pt2_ins_lum )) ; angle retorna o angulo entre dois pontos
  (setq dis_pt1_pt2_ins_lum (/ (distance pt1_ins_lum pt2_ins_lum) 2 )) ; distancia retorna a distancia entre dois pontos

  (setvar "osmode" 0)
  (setq ins_lum (polar pt1_ins_lum ang_pt1_pt2_ins_lum dis_pt1_pt2_ins_lum ))
)

(defun verificar_layer(nome cor)
  (setq layer(tblsearch "layer" nome))
  (if (= layer nil)
    (progn
      (command "layer" "n" nome "c" cor nome "")
      (setvar "clayer" nome)
    )
    (progn
      (setq desligado (cdr (assoc 62 layer)))
      (if (> desligado 0)
        (progn
          (setvar "clayer" nome)
        )
        (progn
          (command "layer" "on" nome "")
          (setvar "clayer" nome)
        )
      )
    )
  )
)
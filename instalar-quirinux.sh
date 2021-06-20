/*Rosa Castiñeiras Fariña
 * 26/04/2021
 * Tarefa 02. GridBagLayout.
 */
package ejemplosLayout;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextField;

public class _02_Tarefa02GridBagLayout extends JFrame {

	public _02_Tarefa02GridBagLayout() {
		// establécese o contenedor, de tipo GridBagLayout
		// malla de 6 de alto por 4 de ancho
		Container panel = getContentPane();
		panel.setLayout(new GridBagLayout());

		// Primeira columna
		// Primeiro botón que simula unha lista
		JButton boton1 = new JButton("Botón lista");
		GridBagConstraints zonaWest = new GridBagConstraints();
		zonaWest.gridx = 0; // posicion
		zonaWest.gridy = 0; // posicion
		zonaWest.gridheight = GridBagConstraints.REMAINDER; // para que esa celda ocupe toda a columna
		zonaWest.gridwidth = 1;
		zonaWest.weightx = 1; // para que se redimensione ao cambiar o tamaño da ventá
		zonaWest.weighty = 1;
		zonaWest.fill = GridBagConstraints.BOTH; // para que ocupe todo o espazo reservado
		zonaWest.anchor = GridBagConstraints.CENTER; // para que o botón se atope centrado dentro da celda
		zonaWest.insets = new Insets(10, 5, 10, 0); // as marxes
		// engádese ao panel final
		panel.add(boton1, zonaWest);

		// Segunda columna
		// etiquetas JLabel
		// etiqueta nome
		JLabel nome = new JLabel("Nome: ");
		GridBagConstraints adxNome = new GridBagConstraints();
		adxNome.gridx = 1;
		adxNome.gridy = 0;
		adxNome.gridwidth = 1; // para que so ocupe unha celda horzintalmente
		adxNome.gridheight = 1; // para que so ocupe unha celda verticalmente
		adxNome.weightx = 0; // para que non redimensione as etiquetas ao cambiar o tamaño da ventá
		adxNome.weighty = 0;
		adxNome.anchor = GridBagConstraints.WEST; // a etiqueta está aliñada á esquerda dentro da celda
		adxNome.fill = GridBagConstraints.BOTH; // Visualmente non se ve afectado
		adxNome.insets = new Insets(10, 5, 10, 30);
		// engádese á zonaEast
		panel.add(nome, adxNome);

		// etiqueta apelidos
		JLabel apelidos = new JLabel("Apelidos: ");
		GridBagConstraints adxApelidos = new GridBagConstraints();
		adxApelidos.gridx = 1;
		adxApelidos.gridy = 1;
		adxApelidos.gridwidth = 1;
		adxApelidos.gridheight = 1;
		adxApelidos.weightx = 0;
		adxApelidos.weighty = 0;
		adxApelidos.anchor = GridBagConstraints.WEST;
		adxApelidos.fill = GridBagConstraints.BOTH;
		adxApelidos.insets = new Insets(10, 5, 10, 30);
		panel.add(apelidos, adxApelidos);

		// etiquetas JRadioButton
		// radio estudante. Por defecto, está marcado
		JRadioButton estudante = new JRadioButton("Estudante", true);
		GridBagConstraints adxEstudante = new GridBagConstraints();
		adxEstudante.gridx = 1;
		adxEstudante.gridy = 2;
		adxEstudante.gridheight = 1;
		adxEstudante.gridwidth = 2;
		adxEstudante.weightx = 0;
		adxEstudante.weighty = 0;
		adxEstudante.anchor = GridBagConstraints.WEST;
		adxEstudante.fill = GridBagConstraints.BOTH;
		adxEstudante.insets = new Insets(10, 5, 10, 0);
		panel.add(estudante, adxEstudante);

		// radio profesorado. Por defeto, non está marcado
		JRadioButton profesorado = new JRadioButton("Profesorado", false);
		GridBagConstraints adxProfesorado = new GridBagConstraints();
		adxProfesorado.gridx = 1;
		adxProfesorado.gridy = 3;
		adxProfesorado.gridheight = 1;
		adxProfesorado.gridwidth = 2;
		adxProfesorado.weightx = 0;
		adxProfesorado.weighty = 0;
		adxProfesorado.anchor = GridBagConstraints.WEST;
		adxProfesorado.fill = GridBagConstraints.BOTH;
		adxProfesorado.insets = new Insets(10, 5, 10, 0);
		panel.add(profesorado, adxProfesorado);

		// Teceira columna
		// etiqueta de texto do nome
		JTextField textoNome = new JTextField("Escriba aquí o seu nome");
		GridBagConstraints adxTextoNome = new GridBagConstraints();
		adxTextoNome.gridx = 2;
		adxTextoNome.gridy = 0;
		adxTextoNome.gridheight = 1;
		adxTextoNome.gridwidth = 2;
		adxTextoNome.weightx = 1;
		adxTextoNome.weighty = 0;
		adxTextoNome.anchor = GridBagConstraints.WEST;
		adxTextoNome.fill = GridBagConstraints.BOTH;
		adxTextoNome.insets = new Insets(10, 0, 10, 5);
		panel.add(textoNome, adxTextoNome);

		// etiqueta de texto dos apelidos
		// apelido 1
		JTextField textoApelido1 = new JTextField("Primeiro apelido");
		GridBagConstraints adxApelido1 = new GridBagConstraints();
		adxApelido1.gridx = 2;
		adxApelido1.gridy = 1;
		adxApelido1.gridheight = 1;
		adxApelido1.gridwidth = GridBagConstraints.RELATIVE;
		adxApelido1.weightx = 1;
		adxApelido1.weighty = 0;
		adxApelido1.anchor = GridBagConstraints.WEST;
		adxApelido1.fill = GridBagConstraints.BOTH;
		adxApelido1.insets = new Insets(10, 0, 10, 5);
		panel.add(textoApelido1, adxApelido1);

		// apelido 2
		JTextField textoApelido2 = new JTextField("Segundo apelido");
		GridBagConstraints adxApelido2 = new GridBagConstraints();
		adxApelido2.gridx = 3;
		adxApelido2.gridy = 1;
		adxApelido2.gridheight = 1;
		adxApelido2.gridwidth = GridBagConstraints.RELATIVE;
		adxApelido2.weightx = 1;
		adxApelido2.weighty = 0;
		adxApelido2.anchor = GridBagConstraints.WEST;
		adxApelido2.fill = GridBagConstraints.BOTH;
		adxApelido2.insets = new Insets(10, 0, 10, 5);
		panel.add(textoApelido2, adxApelido2);

		// Botón Aceptar. Na esquina inferior dereita
		JButton ok = new JButton("Aceptar");
		GridBagConstraints adxOK = new GridBagConstraints();
		adxOK.gridx = 3;
		adxOK.gridy = 5;
		adxOK.gridheight = GridBagConstraints.REMAINDER;
		adxOK.gridheight = GridBagConstraints.REMAINDER;
		// para que sempre esté abaixo
		adxOK.anchor = GridBagConstraints.SOUTHEAST;
		// non interesa que ocupe todo o ancho da súa celda, simplemente o tamaño do
		// botón
		adxOK.fill = GridBagConstraints.NONE; // para que o botón ocupe simplemente o espazo que precisa
		adxOK.insets = new Insets(10, 0, 10, 20);
		adxOK.weightx = 0;
		adxOK.weighty = 0;
		panel.add(ok, adxOK);

		// OUTROS
		this.setTitle("Tarefa02. GridBagLayout.");
		this.setVisible(true);
		this.setSize(600, 350);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	public static void main(String[] args) {
		new _02_Tarefa02GridBagLayout();
	}
}

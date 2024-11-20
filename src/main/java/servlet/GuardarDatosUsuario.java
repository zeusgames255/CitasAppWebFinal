package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBConnection;

public class GuardarDatosUsuario extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String celular = request.getParameter("celular");
        String fechanacimiento = request.getParameter("fechanacimiento");
        String tipo = request.getParameter("tipo");
        String servicio = request.getParameter("servicio");
        String nombreusuario = request.getParameter("nombreusuario");
        String contraseña = request.getParameter("contraseña");
        String fotoperfil = request.getParameter("fotoperfil");  // Nuevo campo de imagen de perfil

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Cargar el Driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establecer la conexión con la base de datos
            con = DBConnection.getConnection();

            // Verificar si el nombre de usuario ya existe en las tablas 'usuario' y 'profesional'
            String checkUserQuery = "SELECT nombreusuario FROM usuario WHERE nombreusuario = ? " +
                                     "UNION SELECT nombreusuario FROM profesional WHERE nombreusuario = ?";
            ps = con.prepareStatement(checkUserQuery);
            ps.setString(1, nombreusuario);
            ps.setString(2, nombreusuario);
            rs = ps.executeQuery();

            // Comprobar si el nombre de usuario ya está registrado
            if (rs.next()) {
                request.setAttribute("mensajeUsuarioRepetido", "Ya existe un usuario con el mismo nombre de usuario.");
                request.getRequestDispatcher("Registrar.jsp").forward(request, response);
                return;
            }

            // Validación de que los nombres y apellidos no se repitan en 'usuario' y 'profesional'
            String checkNameQuery = "SELECT nombres, apellidos FROM usuario WHERE nombres = ? AND apellidos = ? " +
                                    "UNION SELECT nombres, apellidos FROM profesional WHERE nombres = ? AND apellidos = ?";
            ps = con.prepareStatement(checkNameQuery);
            ps.setString(1, nombres);
            ps.setString(2, apellidos);
            ps.setString(3, nombres);
            ps.setString(4, apellidos);
            rs = ps.executeQuery();

            // Comprobar si ya existe un registro con los mismos nombres y apellidos
            if (rs.next()) {
                request.setAttribute("mensajeNombreApellidos", "Ya existe un usuario con el mismo nombre y apellido.");
                request.getRequestDispatcher("Registrar.jsp").forward(request, response);
                return;
            }

            // Determinar la consulta según el tipo de usuario
            String query;
            if ("profesional".equals(tipo)) {
               
                query = "INSERT INTO profesional (nombres, apellidos, celular, fechanacimiento, tipo, servicio, nombreusuario, contraseña, fotoperfil) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(query);
                ps.setString(1, nombres);
                ps.setString(2, apellidos);
                ps.setString(3, celular);
                ps.setString(4, fechanacimiento);
                ps.setString(5, tipo);
                ps.setString(6, servicio);  // Establecer el parámetro para servicio
                ps.setString(7, nombreusuario);
                ps.setString(8, contraseña);
                ps.setString(9, fotoperfil);
                
            } else {
                // Para un usuario, no incluir el campo servicio
                query = "INSERT INTO usuario (nombres, apellidos, celular, fechanacimiento, tipo, nombreusuario, contraseña, fotoperfil) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(query);
                ps.setString(1, nombres);
                ps.setString(2, apellidos);
                ps.setString(3, celular);
                ps.setString(4, fechanacimiento);
                ps.setString(5, tipo);
                ps.setString(6, nombreusuario);
                ps.setString(7, contraseña);
                ps.setString(8, fotoperfil);
            }

       
            // Ejecutar la consulta
            int rowsInserted = ps.executeUpdate();

            // Verificar si se insertaron los datos
            if (rowsInserted > 0) {
            
                request.getRequestDispatcher("mensajeregistroexitoso.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al conectar con la base de datos.");
            request.getRequestDispatcher("Registrar.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error SQL: " + e.getMessage());
            request.getRequestDispatcher("Registrar.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

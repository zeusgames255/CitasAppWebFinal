package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ActualizarFoto")
public class ActualizarFoto extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ActualizarFoto() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Método GET no es necesario en este caso, pero si se llega a invocar, se puede redirigir a la página de perfil o error
        response.sendRedirect("perfilusuario.jsp"); // Redirige a perfilusuario.jsp en caso de llamada GET
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el idusuario de la sesión activa
        HttpSession session = request.getSession();
        Integer idusuario = (Integer) session.getAttribute("idusuario");

        // Verificar si el idusuario está presente en la sesión
        if (idusuario == null) {
            // Si no hay sesión activa, redirigir a la página de login
            response.sendRedirect("login.jsp");
            return;
        }

        // Obtener el link de la foto de perfil desde el formulario
        String nuevaFotoLink = request.getParameter("selectedAvatar");

        if (nuevaFotoLink != null && !nuevaFotoLink.isEmpty()) {
            // Conectar a la base de datos
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                // Configuración de la base de datos con usuario root y contraseña 123456
                String dbURL = "jdbc:mysql://localhost:3306/paginacitas";
                String dbUser = "root";
                String dbPassword = "123456";
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Consulta SQL para actualizar el campo fotoperfil en la tabla usuario
                String sql = "UPDATE usuario SET fotoperfil = ? WHERE idusuario = ?";
                ps = conn.prepareStatement(sql);

                // Establecer los parámetros de la consulta
                ps.setString(1, nuevaFotoLink); // Link de la nueva foto
                ps.setInt(2, idusuario); // idusuario de la sesión activa

                // Ejecutar la actualización
                int result = ps.executeUpdate();

                // Verificar si la actualización fue exitosa
                if (result > 0) {
                    // Actualizar la foto de perfil en la sesión
                    session.setAttribute("fotoperfil", nuevaFotoLink);

                    // Redirigir al perfil del usuario después de actualizar la foto
                    response.sendRedirect("perfilusuario.jsp"); // Redirige a la página de perfil del usuario
                } else {
                    // Redirigir a una página de error si no se actualizó
                    response.sendRedirect("error.jsp");
                }

            } catch (SQLException e) {
                // Manejar excepciones de SQL
                e.printStackTrace();
                response.sendRedirect("error.jsp"); // Redirigir a una página de error en caso de excepciones
            } finally {
                // Cerrar recursos de la base de datos
                try {
                    if (ps != null) {
                        ps.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // Si el link de la foto está vacío o es inválido, redirigir a una página de error
            response.sendRedirect("error.jsp");
        }
    }
}

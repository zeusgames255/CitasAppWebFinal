package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import db.DBConnection;

/**
 * Servlet implementation class EliminarDatosCita
 */
public class EliminarDatosCita extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idcita = request.getParameter("idcita");
        String mensaje = "";

        // Variables para la conexión y las sentencias SQL
        Connection con = null;
        PreparedStatement psCita = null;
        PreparedStatement psHorario = null;
        ResultSet rs = null;

        try {
            // Establecer la conexión con la base de datos
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Iniciar transacción

            // Consulta para obtener el idhorario de la cita
            String queryCita = "SELECT idhorarios FROM cita WHERE idcita = ?";
            psCita = con.prepareStatement(queryCita);
            psCita.setString(1, idcita);
            rs = psCita.executeQuery();

            if (rs.next()) {
                // Obtener el idhorario relacionado con la cita
                String idhorario = rs.getString("idhorarios");

                // Consulta para actualizar el estado en la tabla horarios
                String queryHorario = "UPDATE horarios SET estado = NULL WHERE idhorarios = ?";
                psHorario = con.prepareStatement(queryHorario);
                psHorario.setString(1, idhorario);
                psHorario.executeUpdate();
            }

            // Consulta para eliminar la cita
            String queryEliminar = "DELETE FROM cita WHERE idcita = ?";
            psCita = con.prepareStatement(queryEliminar);
            psCita.setString(1, idcita);
            int rowsDeleted = psCita.executeUpdate();

            // Verificar si se eliminó la cita y confirmar la transacción
            if (rowsDeleted > 0) {
                con.commit(); // Confirmar la transacción
                mensaje = "Cita eliminada y estado del horario actualizado exitosamente.";
            } else {
                con.rollback(); // Revertir la transacción en caso de error
                mensaje = "No se encontró ninguna cita con el ID proporcionado.";
            }
        } catch (SQLException e) {
            try {
                if (con != null) con.rollback(); // Revertir si ocurre un error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            mensaje = "Error al eliminar la cita y actualizar el estado del horario: " + e.getMessage();
        } finally {
            // Cerrar recursos
            try {
                if (rs != null) rs.close();
                if (psCita != null) psCita.close();
                if (psHorario != null) psHorario.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Añadir mensaje al request y redirigir a la página de listado de citas
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("listarcitausuario.jsp").forward(request, response);
    }
}

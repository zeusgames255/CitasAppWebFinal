<%@page import="db.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
    response.setDateHeader("Expires", -1);

    if (session.getAttribute("nombreusuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer idusuario = (Integer) session.getAttribute("idusuario");
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css">

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Arial', sans-serif;
        }
        .card-calendar {
            border: none;
            margin: 20px 0;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease-in-out, box-shadow 0.3s ease;
        }
        .card-calendar:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        .card-header {
            background-color: #000000;
            color: #ffffff;
            font-size: 1.2rem;
            text-align: center;
            padding: 15px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            text-transform: uppercase; /* Convertir el motivo a mayúsculas */
        }
        .btn-detalle {
            background-color: #000000;
            color: #ffffff;
            font-weight: bold;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s;
        }
        .btn-detalle:hover {
            background-color: #333333;
            transform: translateY(-2px);
        }
        .btn-eliminar {
            background-color: #dc3545;
            color: #ffffff;
            font-weight: bold;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s;
        }
        .btn-eliminar:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }
        .card-body {
            padding: 20px;
        }
        .card-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
        }
        .card-text {
            font-size: 0.95rem;
            color: #555;
        }
        .modal-header {
            background-color: #007bff;
            color: #fff;
        }
        .modal-body {
            font-size: 0.95rem;
            color: #333;
        }
        footer {
            background-color: #343a40;
            color: #fff;
            padding: 30px 0;
        }
        footer h5 {
            font-size: 1.5rem;
            margin-bottom: 20px;
        }
        footer a {
            color: #fff;
            text-decoration: none;
            font-weight: 600;
        }
        footer a:hover {
            color: #007bff;
        }
    </style>
</head>
<body>

<div style="background-color: #000000;">
    <div class="text-center py-3" style="background: linear-gradient(to bottom, #fafafa, #f5f5f5);">
        <img src="https://i.ibb.co/M1xqhhQ/logo-citas.png" class="img-fluid img-rounded" alt="Logo" width="900" height="250">
    </div>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link active" href="listarcitausuario.jsp">Mis Citas</a></li>
                    <li class="nav-item"><a class="nav-link" href="crearcita.jsp">Crear cita</a></li>
                    <li class="nav-item"><a class="nav-link" href="listarprofesionalesusuario.jsp">Buscar Profesional</a></li>
                    <li class="nav-item"><a class="nav-link" href="perfilusuario.jsp">Mi Perfil</a></li>
                </ul>
                <ul class="navbar-nav ms-3">
                    <li class="nav-item d-flex align-items-center">
                        <div class="dropdown">
                            <button class="btn p-0" data-bs-toggle="dropdown" aria-expanded="false" style="border: none; background: none;">
                                <img src="<%= session.getAttribute("fotoperfil") != null ? session.getAttribute("fotoperfil") : "https://via.placeholder.com/40" %>" class="rounded-circle" alt="Avatar" width="40" height="40">
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="perfilusuario.jsp">Mi Perfil</a></li>
                                <li><a class="dropdown-item" href="eliminarcuenta.jsp">Eliminar Cuenta</a></li>
                                <li><a class="dropdown-item" href="CerrarSesion">Cerrar Sesión</a></li>
                            </ul>
                        </div>
                        <span class="text-white ms-2"><%= session.getAttribute("nombreusuario") %></span>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</div>

<div class="container">
    <div class="row">
        <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            if (idusuario != null) {
                String query = "SELECT c.idcita, c.fecha, c.hora, c.motivo, c.detalles, p.nombres AS nombre_profesional " +
                               "FROM cita c " +
                               "JOIN profesional p ON c.idprofesional = p.idprofesional " +
                               "WHERE c.idusuario = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setInt(1, idusuario);
                rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No hay citas disponibles.</p>");
                } else {
                    while (rs.next()) {
                        int idcita = rs.getInt("idcita");
                        String fecha = rs.getString("fecha");
                        String hora = rs.getString("hora");
                        String motivo = rs.getString("motivo");
                        String detalles = rs.getString("detalles");
                        String nombreProfesional = rs.getString("nombre_profesional");
        %>
        <div class="col-md-4">
            <div class="card card-calendar">
                <div class="card-header">
                    <%= motivo.toUpperCase() %> <!-- Convertir motivo a mayúsculas -->
                </div>
                <div class="card-body">
                <%
    // Obtener el nombre del día de la semana
    SimpleDateFormat dayFormat = new SimpleDateFormat("EEEE");
    Date citaFecha = new SimpleDateFormat("yyyy-MM-dd").parse(fecha); // Convertir la fecha de String a Date
    String nombreDia = dayFormat.format(citaFecha);
%>
<h5 class="card-title">
    <strong>Fecha:</strong> <%= nombreDia %>, <%= fecha %>
</h5>
                
                    <p class="card-text"><strong>Hora:</strong> <%= hora %></p>
                    <p class="card-text"><strong>Profesional:</strong> <%= nombreProfesional %></p>
                    
                    <p class="card-text"><strong>Tiempo restante:</strong> <span id="timer<%= idcita %>"></span></p>
                    
                    
                    <button type="button" class="btn btn-detalle" data-bs-toggle="modal" data-bs-target="#detalleCita<%= idcita %>">
                        <i class="bi bi-info-circle"></i> Detalle
                    </button>

                    <!-- Botón para mostrar modal de confirmación de cancelación -->
                    <button type="button" class="btn btn-eliminar" data-bs-toggle="modal" data-bs-target="#confirmarEliminarCita<%= idcita %>">
                        <i class="bi bi-trash"></i> Cancelar Cita
                    </button>
                </div>
            </div>
        </div>

        <!-- Modal Confirmación Cancelar Cita -->
        <div class="modal fade" id="confirmarEliminarCita<%= idcita %>" tabindex="-1" aria-labelledby="confirmarEliminarCitaLabel<%= idcita %>" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-warning">
                        <h5 class="modal-title text-black  bg-warning" id="confirmarEliminarCitaLabel<%= idcita %>">Confirmación de Cancelación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Estás seguro de querer eliminar esta cita? El horario del profesional quedará disponible nuevamente.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Volver</button>
                        <form action="EliminarDatosCita" method="POST">
                            <input type="hidden" name="idcita" value="<%= idcita %>">
                            <button type="submit" class="btn btn-danger">Sí, Cancelar Cita</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

<script>
    // Función para contar el tiempo restante
    function updateTimeLeft(citaId, citaFechaHora) {
        const citaTime = new Date(citaFechaHora).getTime();
        const timerElement = document.getElementById("timer" + citaId);

        const interval = setInterval(function () {
            const now = new Date().getTime();
            const distance = citaTime - now;
            const timeSinceCita = now - citaTime;

            if (distance <= 0) {
                if (timeSinceCita >= 24 * 60 * 60 * 1000) { // 1 día en milisegundos
                    clearInterval(interval);
                    timerElement.innerHTML = "¡La cita ha caducado!";
                    timerElement.style.color = "red"; // Cambiar color a rojo
                    timerElement.style.fontWeight = "bold"; // Cambiar a negrita
                } else {
                    timerElement.innerHTML = "¡La cita es hoy!";
                    timerElement.style.color = "green"; // Cambiar color a rojo
                    timerElement.style.fontWeight = "bold"; // Cambiar a negrita
                }
            } else {
                const hours = Math.floor(distance / (1000 * 60 * 60));
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                timerElement.innerHTML = hours + "h " + minutes + "m " + seconds + "s";
            }
        }, 1000);
    }

    // Llamada a la función para cada cita
    <%
        // Enviar el ID de la cita y la fecha/hora en formato adecuado para el JavaScript
        String fechaHoraCita = fecha + " " + hora;  // Asegúrate de que la hora esté en el formato correcto
    %>
    updateTimeLeft(<%= idcita %>, "<%= fechaHoraCita %>");
</script>



        <!-- Modal Detalles -->
        <div class="modal fade" id="detalleCita<%= idcita %>" tabindex="-1" aria-labelledby="detalleCitaLabel<%= idcita %>" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="detalleCitaLabel<%= idcita %>">Detalles de la cita</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p><strong>Motivo:</strong> <%= motivo %></p>
                        <p><strong>Detalles:</strong> <%= detalles %></p>
                        <p><strong>Fecha:</strong> <%= fecha %></p>
                        <p><strong>Hora:</strong> <%= hora %></p>
                        <p><strong>Profesional:</strong> <%= nombreProfesional %></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <form action="ModificarCita" method="POST">
                            <input type="hidden" name="idcita" value="<%= idcita %>">
                           
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <% 
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.min.js"></script>





</body>


<footer class="bg-dark text-white text-center mt-5 py-4">
  <h5>Agendame</h5>
  <ul class="list-unstyled d-flex justify-content-center mb-3">
    <li class="mx-3"><a href="#about" class="text-white text-decoration-none">Acerca de</a></li>
    <li class="mx-3"><a href="#services" class="text-white text-decoration-none">Servicios</a></li>
    <li class="mx-3"><a href="#contact" class="text-white text-decoration-none">Contacto</a></li>
  </ul>
  <ul class="list-unstyled d-flex justify-content-center mb-3">
    <li class="mx-3"><a href="https://www.facebook.com" target="_blank" class="text-white"><i class="bi bi-facebook"></i></a></li>
    <li class="mx-3"><a href="https://www.twitter.com" target="_blank" class="text-white"><i class="bi bi-twitter"></i></a></li>
    <li class="mx-3"><a href="https://www.instagram.com" target="_blank" class="text-white"><i class="bi bi-instagram"></i></a></li>
  </ul>
  <p class="mb-0">© 2024 Nombre de tu Sitio Web. Todos los derechos reservados.</p>
</footer>
</html>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des assignations - Reserve</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        <%@ include file="/assets/theme.css" %>
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    
    <main class="page-main">
        <section class="content-card">
            <div class="assignation-container">
                
                <!-- En-tête avec icône -->
                <div class="assignation-header">
                    <div class="header-icon">
                        <i class="fas fa-route"></i>
                    </div>
                    <div class="header-content">
                        <h1 class="page-title">Gestion des assignations</h1>
                        <p class="header-description">
                            Optimisez l'allocation de vos véhicules en fonction des réservations
                        </p>
                    </div>
                </div>

                <!-- Statistiques rapides (optionnel) -->
                <div class="stats-cards">
                    <div class="stat-mini-card">
                        <div class="stat-mini-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-mini-content">
                            <span class="stat-mini-label">Assignations actives</span>
                            <span class="stat-mini-value" id="activeCount">0</span>
                        </div>
                    </div>
                    <div class="stat-mini-card">
                        <div class="stat-mini-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-mini-content">
                            <span class="stat-mini-label">En attente</span>
                            <span class="stat-mini-value" id="pendingCount">0</span>
                        </div>
                    </div>
                    <div class="stat-mini-card">
                        <div class="stat-mini-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-mini-content">
                            <span class="stat-mini-label">Taux d'occupation</span>
                            <span class="stat-mini-value" id="occupancyRate">78%</span>
                        </div>
                    </div>
                </div>

                <!-- Message d'information -->
                <div class="info-message">
                    <i class="fas fa-info-circle"></i>
                    <span>Choisissez une option pour gérer vos assignations</span>
                </div>

                <!-- Grille des actions principales -->
                <div class="actions-grid">
                    
                    <!-- Carte: Méthode d'assignation -->
                    <div class="action-card">
                        <div class="card-icon method-icon">
                            <i class="fas fa-cogs"></i>
                        </div>
                        <h3>Méthode d'assignation</h3>
                        <p>Choisissez entre assignation automatique ou manuelle selon vos besoins</p>
                        <div class="card-features">
                            <span><i class="fas fa-robot"></i> Auto</span>
                            <span><i class="fas fa-user-cog"></i> Manuel</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/assignation/method" class="action-link">
                            Configurer <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Carte: Liste des assignations -->
                    <div class="action-card">
                        <div class="card-icon list-icon">
                            <i class="fas fa-list-alt"></i>
                        </div>
                        <h3>Liste des assignations</h3>
                        <p>Visualisez toutes les assignations en cours et passées</p>
                        <div class="card-features">
                            <span><i class="fas fa-eye"></i> Vue détaillée</span>
                            <span><i class="fas fa-filter"></i> Filtres</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/assignation/list" class="action-link">
                            Voir la liste <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Carte: Filtrer par date -->
                    <div class="action-card highlight-card">
                        <div class="card-icon filter-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <h3>Filtrer par date</h3>
                        <p>Recherchez des assignations pour une période spécifique</p>
                        <div class="card-features">
                            <span><i class="fas fa-calendar-day"></i> Journalier</span>
                            <span><i class="fas fa-calendar-week"></i> Hebdomadaire</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/assignation/filter" class="action-link">
                            Filtrer <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>

                </div>

                <!-- Section d'aide rapide -->
                <div class="quick-help">
                    <div class="help-header">
                        <i class="fas fa-question-circle"></i>
                        <h4>Besoin d'aide ?</h4>
                    </div>
                    <div class="help-content">
                        <p>Consultez notre guide d'utilisation pour les assignations</p>
                        <a href="#" class="help-link">
                            <i class="fas fa-book-open"></i>
                            Guide d'assignation
                        </a>
                    </div>
                </div>

                <!-- Raccourcis récents (optionnel) -->
                <div class="recent-actions">
                    <h4>Actions récentes</h4>
                    <div class="recent-list" id="recentActions">
                        <div class="recent-item">
                            <i class="fas fa-history"></i>
                            <span>Assignation automatique - 10 mars 2026</span>
                        </div>
                        <div class="recent-item">
                            <i class="fas fa-history"></i>
                            <span>Filtrage par date - 9 mars 2026</span>
                        </div>
                    </div>
                </div>

                <!-- Navigation secondaire -->
                <div class="secondary-nav">
                    <a href="${pageContext.request.contextPath}/backoffice" class="nav-link back">
                        <i class="fas fa-arrow-left"></i>
                        Retour au backoffice
                    </a>
                    <a href="${pageContext.request.contextPath}/assignation/statistiques" class="nav-link stats">
                        <i class="fas fa-chart-bar"></i>
                        Voir les statistiques
                    </a>
                </div>

            </div>
        </section>
    </main>

    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>

    <!-- Script pour les statistiques (optionnel) -->
    <script>
        // Animation des compteurs (simulée)
        document.addEventListener('DOMContentLoaded', function() {
            // Simuler le chargement des données
            setTimeout(() => {
                animateValue('activeCount', 0, 24, 1000);
                animateValue('pendingCount', 0, 8, 1000);
            }, 200);
        });

        function animateValue(elementId, start, end, duration) {
            const element = document.getElementById(elementId);
            const range = end - start;
            const increment = range / (duration / 16);
            let current = start;
            
            const timer = setInterval(() => {
                current += increment;
                if (current >= end) {
                    current = end;
                    clearInterval(timer);
                }
                element.textContent = Math.round(current);
            }, 16);
        }
    </script>
</body>
</html>
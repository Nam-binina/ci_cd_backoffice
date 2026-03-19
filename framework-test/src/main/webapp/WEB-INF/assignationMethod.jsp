<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choix méthode d'assignation - Reserve</title>
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
            <div class="method-container">

                <!-- Fil d'Ariane -->
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/assignation/page">
                        <i class="fas fa-route"></i> Assignations
                    </a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Choix méthode</span>
                </div>

                <!-- En-tête de page amélioré -->
                <div class="method-header">
                    <div class="header-badge">
                        <i class="fas fa-cog fa-spin"></i>
                        <span>Étape 1/2</span>
                    </div>
                    <h1 class="page-title">Choisir la méthode d'assignation</h1>
                    <p class="header-subtitle">
                        Sélectionnez le mode de traitement qui correspond à vos besoins
                    </p>
                </div>

                <!-- Grille de comparaison des méthodes -->
                <div class="methods-comparison">
                    
                    <!-- Option Automatique -->
                    <div class="method-card auto-card">
                        <div class="card-ribbon">RECOMMANDÉ</div>
                        <div class="card-header">
                            <div class="method-icon-wrapper">
                                <i class="fas fa-robot"></i>
                            </div>
                            <h2>Assignation Automatique</h2>
                            <div class="method-badge">Intelligent</div>
                        </div>

                        <div class="card-body">
                            <div class="method-description">
                                <p>L'algorithme optimise automatiquement l'assignation des véhicules en fonction de multiples critères.</p>
                            </div>

                            <div class="features-list">
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Optimisation par TA (Temps d'Arrivée)</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Regroupement intelligent des réservations</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Calcul automatique des trajets optimaux</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Gestion de la capacité des véhicules</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Rapport détaillé post-assignation</span>
                                </div>
                            </div>

                            <div class="performance-indicator">
                                <div class="perf-item">
                                    <span class="perf-label">Vitesse</span>
                                    <div class="perf-bar">
                                        <div class="perf-fill" style="width: 95%"></div>
                                    </div>
                                    <span class="perf-value">Très rapide</span>
                                </div>
                                <div class="perf-item">
                                    <span class="perf-label">Précision</span>
                                    <div class="perf-bar">
                                        <div class="perf-fill" style="width: 98%"></div>
                                    </div>
                                    <span class="perf-value">Optimale</span>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/assignation/method/auto" class="method-btn auto-btn">
                                <span>Lancer l'assignation automatique</span>
                                <i class="fas fa-arrow-right"></i>
                            </a>
                            <div class="btn-help">
                                <i class="fas fa-info-circle"></i>
                                Traitement en lots
                            </div>
                        </div>
                    </div>

                    <!-- Option Manuel -->
                    <div class="method-card manual-card">
                        <div class="card-header">
                            <div class="method-icon-wrapper">
                                <i class="fas fa-user-cog"></i>
                            </div>
                            <h2>Assignation Manuelle</h2>
                            <div class="method-badge">Personnalisé</div>
                        </div>

                        <div class="card-body">
                            <div class="method-description">
                                <p>Contrôle total sur l'assignation avec une interface intuitive de glisser-déposer.</p>
                            </div>

                            <div class="features-list">
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Contrôle total sur chaque assignation</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Interface visuelle de planification</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Ajustements en temps réel</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Validation avant confirmation</span>
                                </div>
                                <div class="feature">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Historique des modifications</span>
                                </div>
                            </div>

                            <div class="performance-indicator">
                                <div class="perf-item">
                                    <span class="perf-label">Flexibilité</span>
                                    <div class="perf-bar">
                                        <div class="perf-fill" style="width: 100%"></div>
                                    </div>
                                    <span class="perf-value">Maximale</span>
                                </div>
                                <div class="perf-item">
                                    <span class="perf-label">Contrôle</span>
                                    <div class="perf-bar">
                                        <div class="perf-fill" style="width: 100%"></div>
                                    </div>
                                    <span class="perf-value">Total</span>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/assignation/method/manual" class="method-btn manual-btn">
                                <span>Configurer manuellement</span>
                                <i class="fas fa-arrow-right"></i>
                            </a>
                            <div class="btn-help">
                                <i class="fas fa-clock"></i>
                                Temps réel
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Tableau comparatif détaillé -->
                <div class="comparison-table-wrapper">
                    <h3>Comparaison détaillée des méthodes</h3>
                    <table class="comparison-table">
                        <thead>
                            <tr>
                                <th>Critère</th>
                                <th>Assignation Automatique</th>
                                <th>Assignation Manuelle</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Temps de traitement</td>
                                <td><i class="fas fa-bolt" style="color: var(--gold);"></i> Très rapide</td>
                                <td><i class="fas fa-hourglass-half"></i> Variable</td>
                            </tr>
                            <tr>
                                <td>Optimisation</td>
                                <td><i class="fas fa-chart-line" style="color: var(--teal);"></i> Algorithmique</td>
                                <td><i class="fas fa-sliders-h"></i> Manuel</td>
                            </tr>
                            <tr>
                                <td>Volume de réservations</td>
                                <td>Illimité</td>
                                <td>Recommandé -50</td>
                            </tr>
                            <tr>
                                <td>Personnalisation</td>
                                <td>Standard</td>
                                <td><i class="fas fa-star" style="color: var(--gold);"></i> Totale</td>
                            </tr>
                            <tr>
                                <td>Rapport généré</td>
                                <td><i class="fas fa-file-alt"></i> Automatique</td>
                                <td><i class="fas fa-edit"></i> À la demande</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Conseils d'utilisation -->
                <div class="usage-tips">
                    <div class="tips-header">
                        <i class="fas fa-lightbulb"></i>
                        <h4>Conseils d'utilisation</h4>
                    </div>
                    <div class="tips-grid">
                        <div class="tip-item">
                            <div class="tip-icon">🤖</div>
                            <div class="tip-content">
                                <strong>Automatique</strong>
                                <p>Idéal pour les grands volumes et les assignations régulières</p>
                            </div>
                        </div>
                        <div class="tip-item">
                            <div class="tip-icon">👤</div>
                            <div class="tip-content">
                                <strong>Manuel</strong>
                                <p>Parfait pour les cas complexes ou spécifiques nécessitant une attention particulière</p>
                            </div>
                        </div>
                        <div class="tip-item">
                            <div class="tip-icon">🔄</div>
                            <div class="tip-content">
                                <strong>Hybride</strong>
                                <p>Vous pouvez alterner les méthodes selon vos besoins</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions secondaires -->
                <div class="secondary-actions">
                    <a href="${pageContext.request.contextPath}/assignation/page" class="secondary-link">
                        <i class="fas fa-arrow-left"></i>
                        Retour page assignation
                    </a>
                    <a href="${pageContext.request.contextPath}/assignation/help" class="secondary-link">
                        <i class="fas fa-question-circle"></i>
                        Aide sur les méthodes
                    </a>
                </div>

                <!-- Section statistiques (optionnelle) -->
                <div class="method-stats">
                    <div class="stat-badge">
                        <i class="fas fa-chart-pie"></i>
                        <span>Répartition des choix</span>
                    </div>
                    <div class="stat-bar">
                        <div class="stat-bar-auto" style="width: 75%">
                            <span>Automatique 75%</span>
                        </div>
                        <div class="stat-bar-manual" style="width: 25%">
                            <span>Manuel 25%</span>
                        </div>
                    </div>
                </div>

            </div>
        </section>
    </main>

    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>

    <script>
        // Animation des cartes au survol
        document.querySelectorAll('.method-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Animation des barres de performance
        function animatePerfBars() {
            document.querySelectorAll('.perf-fill').forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 200);
            });
        }

        // Lancer l'animation au chargement
        window.addEventListener('load', animatePerfBars);
    </script>
</body>
</html>
from django.urls import path
from .views import MatchListAPIView
from .views import MatchCreateAPIView  
from .views import StadiumSectionsView
from .views import SectionSeatsView
# from .views import StadiumDetailView
# from .views import TeamDetailView
from .views import TeamViewSet
from .views import  MatchDetailAPIView
# from .views import StadiumListCreateAPIView
from django.urls import path, include
from rest_framework.routers import DefaultRouter
# from .views import StadiumCreateAPIView
from .views import StadiumSectionCreateAPIView
from .views import StadiumViewSet
from django.urls import path, include
from .views import UploadTeamLogoView
from .views import UploadStadiumLayoutView
from .views import CheckMatchTodayAPIView
from.views import MatchUpdateWithHistoryAPIView
from rest_framework.routers import DefaultRouter
from .views import MatchHistoryListAPIView
from .views import (
    StadiumListAPIView,
    LeagueListAPIView,
    TeamListAPIView,
    MatchCreateAPIView,
    SectionUpdateAPIView,
    SectionDeleteAPIView,
     LeagueViewSet,

)
router = DefaultRouter()
router.register(r'stadiums', StadiumViewSet, basename='stadium')
router.register(r'leagues', LeagueViewSet, basename='league')
router.register(r'teams', TeamViewSet, basename='teams')

# lấy ds các trận 
urlpatterns = [
    # urls.py (app events)
    path('matches/<int:match_id>/update-with-history/', MatchUpdateWithHistoryAPIView.as_view(), name='match-update-with-history'),
    path('match-history/', MatchHistoryListAPIView.as_view(), name='match-history-list'),    path('matches/', MatchListAPIView.as_view(), name='match-list'),
    path('matches/<int:match_id>/', MatchDetailAPIView.as_view(), name='match-detail'),
    path('matches/create/', MatchCreateAPIView.as_view(), name='match-create'),
    path('api/events/matches/check/', CheckMatchTodayAPIView.as_view(), name='check-match-today'),
    path('creat/stadiums/', StadiumListAPIView.as_view(), name='stadium-list'),
    path('creat/leagues/', LeagueListAPIView.as_view(), name='league-list'),
    path('creat/teams/', TeamListAPIView.as_view(), name='team-list'),
    
    # path('teams/', TeamListAPIShowView.as_view(), name='team-list'),
    path('teams/<int:team_id>/upload-logo/', UploadTeamLogoView.as_view(), name='upload-team-logo'),
    path('stadiums/<int:stadium_id>/upload-layout/', UploadStadiumLayoutView.as_view(), name='upload-stadium-layout'),

    # path('leagues/', LeagueListAPIShowView.as_view(), name='league-list'),
    # path('stadiums/', StadiumListAPIShowView.as_view(), name='stadium-list'),
    path('stadiums/<int:stadium_id>/sections/', StadiumSectionsView.as_view(), name='stadium-sections'),
    path('stadiums/<int:stadium_id>/sections/<int:section_id>/seats/', SectionSeatsView.as_view()),
    # tạo sânsân
    # path('stadiums/create/', StadiumCreateAPIView.as_view(), name='stadium-create'),
    
    # path('stadiums/create/', StadiumListCreateAPIView.as_view(), name='stadium-create'),
    
    # path('stadiums/<int:stadium_id>/', StadiumDetailView.as_view(), name='stadium-update'),
    # path('teams/<int:team_id>/', TeamDetailView.as_view(), name='team-update'),
    # path('leagues/<int:league_id>/', LeagueDetailView.as_view(), name='league-update'),
    # thêm section cho sân
    path('stadiums/<int:stadium_id>/sections/create/', StadiumSectionCreateAPIView.as_view(), name='stadium-section-create'),  # Thêm mới section,
    # update section
    path('stadiums/<int:stadium_id>/sections/<int:section_id>/update/', SectionUpdateAPIView.as_view(), name='section-update'),
    # xóa section
    path('stadiums/<int:stadium_id>/sections/<int:section_id>/delete/', SectionDeleteAPIView.as_view(), name='section-delete'),
    path('', include(router.urls)),
]


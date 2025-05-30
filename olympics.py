# olympics.py
# Licensed with the MIT license.

import configparser
from operator import itemgetter
from sqlalchemy import ForeignKey, create_engine, select
from sqlalchemy.orm import DeclarativeBase, Mapped, declarative_base, mapped_column, relationship, sessionmaker

class Base(DeclarativeBase):
    pass

class AthleteEvent(Base):
    __tablename__ = 'athlete_event'
    athlete_event_id: Mapped[int] = mapped_column(primary_key = True)
    name: Mapped[str] = mapped_column()
    team: Mapped[str] = mapped_column()
    medal: Mapped[str] = mapped_column()
    year: Mapped[int] = mapped_column()
    season: Mapped[str] = mapped_column()
    city: Mapped[str] = mapped_column()
    sport: Mapped[str] = mapped_column()
    event: Mapped[str] = mapped_column()
    medal: Mapped[str] = mapped_column()
    noc: Mapped[str] = mapped_column(ForeignKey('noc_region.noc'))
    noc_region = relationship("NOCRegion", back_populates="athlete_events")
    
    def __str__(self):
        return f"{self.name} {self.noc} {self.season} {self.year} {self.event} {self.medal}"
    
    def __repr__(self):
        return f"{self.name} {self.noc} {self.season} {self.year} {self.event} {self.medal}"
    
class NOCRegion(Base):
    __tablename__ = 'noc_region'
    noc: Mapped[str] = mapped_column(primary_key = True)
    region: Mapped[str]
    athlete_events = relationship("AthleteEvent", back_populates="noc_region")

# Configuring your database connection

config = configparser.ConfigParser()
config.read('config.ini')
u, pw, host, db = itemgetter('username', 'password', 'host', 'database')(config['db'])
dsn = f'postgresql://{u}:{pw}@{host}/{db}'

print(f'using dsn: {dsn}')

# SQLAlchemy engine, base class and session setup

engine = create_engine(dsn, echo=True)
Base = declarative_base()
Session = sessionmaker(engine)
session = Session()

athleteEvent = AthleteEvent()
athleteEvent.name = "Yuto Horigome"
athleteEvent.team = "Japan"
athleteEvent.medal = "Gold"
athleteEvent.year = 2020
athleteEvent.season = "Summer"
athleteEvent.city = "Tokyo"
athleteEvent.noc = 'JPN'
athleteEvent.sport = "Skateboarding"
athleteEvent.event = "Skatboarding, Street, Men"

session.add(athleteEvent)
session.commit()

query = select(AthleteEvent).where(
    AthleteEvent.noc == 'JPN',
    AthleteEvent.year >= 2016,
    AthleteEvent.medal == 'Gold'
)
results = session.scalars(query).all()

for result in results:
    print(f"{result.name}\t{result.noc_region.region}\t{result.event}\t{result.year}\t{result.season}")

session.close()

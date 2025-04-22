# olympics.py
# Licensed with the MIT license.

import configparser
from operator import itemgetter
from sqlalchemy import ForeignKey, create_engine
from sqlalchemy.orm import DeclarativeBase, Mapped, declarative_base, mapped_column, relationship, sessionmaker

class Base(DeclarativeBase):
    pass

class AthleteEvent(Base):
    __tablename__ = 'athlete_event'
    athlete_event_id: Mapped[int] = mapped_column(primary_key = True)
    name: Mapped[str] = mapped_column()
    noc: Mapped[str] = mapped_column(ForeignKey('noc_region.noc'))
    season: Mapped[str] = mapped_column()
    year: Mapped[int] = mapped_column()
    event: Mapped[str] = mapped_column()
    medal: Mapped[str] = mapped_column()
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
athleteEvent.name = "Yurr"

session.add(athleteEvent)
session.commit()

session.close()
